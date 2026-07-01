import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/features/auth/state/login_state.dart';
import 'package:flutter_app/ats/utils/shared_ref.dart';

class AtsLoginCubit extends Cubit<AtsLoginState> {
  AtsLoginCubit() : super(const AtsLoginState());

  void onUsernameChanged(String value) {
    emit(state.copyWith(
      username: value,
      usernameError: null,
      status: AtsLoginStatus.initial,
      errorMessage: null,
    ));
  }

  void onPasswordChanged(String value) {
    emit(state.copyWith(
      password: value,
      passwordError: null,
      status: AtsLoginStatus.initial,
      errorMessage: null,
    ));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  Future<void> login({
    required String usernameErrorMsg,
    required String passwordErrorMsg,
  }) async {
    // 1. Validation
    bool hasError = false;
    String? usernameError;
    String? passwordError;

    if (state.username.trim().isEmpty) {
      usernameError = usernameErrorMsg;
      hasError = true;
    }

    if (state.password.trim().isEmpty) {
      passwordError = passwordErrorMsg;
      hasError = true;
    }

    if (hasError) {
      emit(state.copyWith(
        usernameError: usernameError,
        passwordError: passwordError,
      ));
      return;
    }

    final username = state.username;
    final password = state.password;
    debugPrint('--- Login Process Started ---');
    debugPrint('Input Username: $username');
    debugPrint('Input Password: $password');

    const baseUrl = ApiConfig.baseUrl;
    debugPrint('Using Base URL: $baseUrl');
    const db = ApiConfig.dbName;
    debugPrint('Using Database: $db');
    final odooService = OdooService(baseUrl);

    emit(state.copyWith(status: AtsLoginStatus.loading));

    try {
      // 1. Authenticate
      debugPrint('Method: authenticate(db: $db, user: $username) - Calling...');
      final session = await odooService.authenticate(db, username, password);
      debugPrint(
        'Method: authenticate - Result: Session ID ${session.id}, User ID ${session.userId}',
      );

      final prefs = SharedPref();
      await prefs.saveObject('session', session);
      await prefs.saveString('baseUrl', baseUrl);
      await prefs.saveString('db', db);
      await prefs.saveObject('port', 7075); // Example port value
      await prefs.saveBool('isLoggedIn', true);
      await prefs.saveBool('rememberMe', state.rememberMe);

      if (state.rememberMe) {
        await prefs.saveString('saved_username', username);
        await prefs.saveString('saved_password', password);
      } else {
        await prefs.remove('saved_username');
        await prefs.remove('saved_password');
      }

      // 2. Fetch User Profile (res.users) once at login
      debugPrint('Fetching user profile data from res.users...');
      final userResult = await odooService.callKw({
        'model': 'res.users',
        'method': 'search_read',
        'args': [
          [['id', '=', session.userId]]
        ],
        'kwargs': {
          'limit': 1,
          'fields': [
            'name', 
            'login', 
            'email', 
            'company_id', 
            'company_ids', 
            'share', 
            'lang', 
            'tz', 
            'groups_id', 
            'partner_id',
            'active',
            'signature',
            'notification_type',
            'image_1920',
            'mobile',
            'website'
          ],
        },
      });

      if (userResult != null && userResult is List && userResult.isNotEmpty) {
        final userData = userResult[0] as Map<String, dynamic>;
        await prefs.saveObject('user_profile', userData);
        debugPrint('User profile saved successfully.');
      } else {
        debugPrint('Failed to fetch user profile.');
      }

      // 4. Get User Groups
      debugPrint(
        'Method: callKw(res.users, search_read) - Checking groups for userId: ${session.userId}',
      );
      final isInternal = await odooService.isInternalUser(session.userId);
      debugPrint('User belongs to Internal User group (96): $isInternal');
      await prefs.saveBool('isInternalUser', isInternal);

      await prefs.saveString('partner_id', session.partnerId.toString());
      debugPrint('Partner ID Saved: ${session.partnerId}');

      debugPrint('--- Login Process Success ---');
      emit(state.copyWith(status: AtsLoginStatus.success));
    } on OdooSessionExpiredException {
      debugPrint('--- Login Process Failed: Session Expired ---');
      emit(
        state.copyWith(
          status: AtsLoginStatus.failure,
          errorMessage: "Session expired. Please log in again.",
        ),
      );
    } on OdooException catch (e) {
      debugPrint('--- Login Process Failed: Odoo Exception ($e) ---');
      emit(
        state.copyWith(
          status: AtsLoginStatus.failure,
          errorMessage: "Wrong login or password",
        ),
      );
    } catch (e) {
      debugPrint('--- Login Process Failed: Unexpected Error ($e) ---');
      emit(
        state.copyWith(
          status: AtsLoginStatus.failure,
          errorMessage: "An error occurred: ${e.toString()}",
        ),
      );
    } finally {
      odooService.close();
      debugPrint('--- Odoo Client Closed ---');
    }
  }

  Future<void> checkAtsLoginStatus() async {
    final prefs = SharedPref();
    final rememberMe = await prefs.getBool('rememberMe') ?? false;
    final savedUsername = await prefs.getString('saved_username') ?? '';
    final savedPassword = await prefs.getString('saved_password') ?? '';

    // Initialize state with remembered credentials if available
    emit(state.copyWith(
      rememberMe: rememberMe,
      username: savedUsername,
      password: savedPassword,
    ));

    final sessionData = await prefs.getObject('session');

    if (sessionData != null && sessionData is Map && sessionData.isNotEmpty) {
      final baseUrl =
          await prefs.getString('baseUrl') ?? ApiConfig.baseUrl;

      // Reconstruction of OdooSession
      final session = OdooSession(
        id: sessionData['id']?.toString() ?? '',
        userId: sessionData['userId'] is int
            ? sessionData['userId']
            : int.parse(sessionData['userId']?.toString() ?? '0'),
        partnerId: sessionData['partnerId'] is int
            ? sessionData['partnerId']
            : int.parse(sessionData['partnerId']?.toString() ?? '0'),
        companyId: sessionData['companyId'] is int
            ? sessionData['companyId']
            : int.parse(sessionData['companyId']?.toString() ?? '0'),
        allowedCompanies: const <Company>[],
        userLogin: sessionData['userLogin']?.toString() ?? '',
        userName: sessionData['userName']?.toString() ?? '',
        userLang: sessionData['userLang']?.toString() ?? "en_US",
        userTz: sessionData['userTz']?.toString() ?? "UTC",
        isSystem: sessionData['isSystem'] is bool
            ? sessionData['isSystem']
            : false,
        dbName: sessionData['dbName']?.toString() ?? 'ftprotech',
        serverVersion: sessionData['serverVersion']?.toString() ?? "",
      );

      final client = OdooClient(baseUrl, sessionId: session);

      try {
        debugPrint('Checking Odoo session validity...');
        await client.checkSession();
        debugPrint('Session is valid.');

        emit(state.copyWith(status: AtsLoginStatus.success));
      } catch (e) {
        debugPrint('Session check failed or expired: $e');
        // If session fails, clear credentials
        await _clearSessionData(prefs);
        emit(state.copyWith(status: AtsLoginStatus.initial));
      } finally {
        client.close();
      }
    } else {
      debugPrint('No saved session found.');
      emit(state.copyWith(status: AtsLoginStatus.initial));
    }
  }

  Future<void> logout() async {
    debugPrint('--- Logout Process Started ---');
    final prefs = SharedPref();
    await _clearSessionData(prefs);
    emit(state.copyWith(status: AtsLoginStatus.initial));
    debugPrint('--- Logout Process Complete ---');
  }

  Future<void> _clearSessionData(SharedPref prefs) async {
    debugPrint('Clearing session data from SharedPref...');
    await prefs.remove('session');
    await prefs.remove('isLoggedIn');
    await prefs.remove('employee_data');
    await prefs.remove('employee_id');
    await prefs.remove('profile_pic');
    await prefs.remove('partner_id');
    await prefs.remove('isInternalUser');
    await prefs.remove('user_profile');
    
    // Do NOT remove rememberMe, saved_username, saved_password here,
    // so they persist after logout for pre-filling the login screen.
    
    // Clear chat related data too if it exists
    await prefs.remove('chat_server_url');
    await prefs.remove('chat_db_name');
    await prefs.remove('chat_username');
    await prefs.remove('chat_password');
  }
}
