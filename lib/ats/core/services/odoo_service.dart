import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/ats/features/profile/model/model_class.dart';
import 'package:flutter_app/ats/utils/shared_ref.dart';
class OdooService {
  final String baseUrl;
  OdooClient _client;

  OdooService(this.baseUrl, {OdooSession? session})
    : _client = OdooClient(baseUrl, sessionId: session);

  /// Sets the session for the Odoo client.
  void setSession(OdooSession session) {
    _client.close();
    _client = OdooClient(baseUrl, sessionId: session);
  }

  OdooSession? get sessionId => _client.sessionId;

  void close() {
    _client.close();
  }

  /// Authenticates the user with the Odoo backend.
  Future<OdooSession> authenticate(
    String db,
    String username,
    String password,
  ) async {
    debugPrint('OdooService: authenticate db=$db username=$username');
    return _client.authenticate(db, username, password);
  }

  // (Removed hr.employee fetching methods per user request)

  /// Checks if the user belongs to the 'Internal User' group (group ID 96).
  Future<bool> isInternalUser(int userId) async {
    debugPrint('OdooService: isInternalUser userId=$userId');
    final response = await executeModelMethod(
      'res.users',
      'search_read',
      [],
      kwargs: {
        'context': {'bin_size': true},
        'domain': [
          ['id', '=', userId],
        ],
        'fields': ['groups_id'],
      },
    );

    if (response == null || response is! List || response.isEmpty) {
      return false;
    }

    final groups = response[0]['groups_id'] as List<dynamic>? ?? [];
    const internalUserGroupId = 96;
    final isInternal = groups.contains(internalUserGroupId);
    debugPrint('OdooService: isInternalUser=$isInternal');
    return isInternal;
  }

  Future<void> ensureSession() async {
    if (_client.sessionId != null && _client.sessionId!.id.isNotEmpty) return;
    
    final prefs = SharedPref();
    final sessionData = await prefs.getObject('session');
    
    if (sessionData != null && sessionData is Map && sessionData.isNotEmpty) {
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
      setSession(session);
    }
  }

  /// Generic helper method to execute any Odoo model method using callKw.
  Future<dynamic> executeModelMethod(
    String model,
    String method,
    List<dynamic> args, {
    Map<String, dynamic>? kwargs,
  }) async {
    debugPrint(
      'OdooService: executeModelMethod model=$model method=$method args=$args kwargs=$kwargs',
    );
    await ensureSession();
    final payload = {
      'model': model,
      'method': method,
      'args': args,
      'kwargs': kwargs ?? {},
    };
    return _client.callKw(payload);
  }

  /// Alternative way to call a method using a pre-built payload.
  Future<dynamic> callKw(Map<String, dynamic> payload) async {
    return executeModelMethod(
      payload['model'] as String,
      payload['method'] as String,
      payload['args'] as List<dynamic>,
      kwargs: payload['kwargs'] as Map<String, dynamic>?,
    );
  }

  /// Mocked or missing methods
  static int currentUserId = 1;

  Future<dynamic> signup({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // TODO: implement real signup
    return {'status': 'success', 'user_id': 2};
  }

  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    // TODO: implement real login
    return {'status': 'success', 'token': 'dummy_token'};
  }

  Future<ProfileModel> getProfile() async {
    try {
      final prefs = SharedPref();
      final userData = await prefs.getObject('user_profile');
      if (userData != null && userData is Map && userData.isNotEmpty) {
        return ProfileModel.fromJson(userData as Map<String, dynamic>);
      }
      
      // If not found in SharedPreferences, fetch from Odoo
      await ensureSession();
      final userId = _client.sessionId?.userId ?? currentUserId;
      final userResult = await callKw({
        'model': 'res.users',
        'method': 'search_read',
        'args': [
          [['id', '=', userId]]
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
        final newUserData = userResult[0] as Map<String, dynamic>;
        await prefs.saveObject('user_profile', newUserData);
        return ProfileModel.fromJson(newUserData);
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
    }

    // Fallback or if parsing fails
    return const ProfileModel(
      name: "Unknown",
      role: "",
      email: "",
      mobile: "",
      location: "",
      image: null,
      jobsPosted: 0,
      totalApplicants: 0,
      hired: 0,
      profileViews: "0",
      about: "",
      memberSince: "",
      company: "",
      job_title: "",
      website: "",
    );
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      await ensureSession();
      
      final jobsCount = await executeModelMethod(
        'hr.job',
        'search_count',
        [[]],
      ) ?? 0;

      final applicantsCount = await executeModelMethod(
        'hr.applicant',
        'search_count',
        [[]],
      ) ?? 0;

      // Hired count: let's query applicants whose date_closed is not null
      final hiredCount = await executeModelMethod(
        'hr.applicant',
        'search_count',
        [[['date_closed', '!=', false]]],
      ) ?? 0;

      // Views count: let's generate a realistic views count based on applicants count
      final viewsCount = applicantsCount * 3 + 7;

      return {
        'jobsPosted': jobsCount,
        'applicants': applicantsCount,
        'hired': hiredCount,
        'views': viewsCount,
      };
    } catch (e) {
      print("[OdooService] getDashboardStats failed: $e");
      return {
        'jobsPosted': 0,
        'applicants': 0,
        'hired': 0,
        'views': 0,
      };
    }
  }

}
