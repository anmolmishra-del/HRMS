import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_app/ats/core/services/odoo_service.dart';
import 'package:flutter_app/ats/core/constants/api_config.dart';
import 'package:flutter_app/ats/features/signup/state/signup_state.dart';

class SignupCubit
    extends Cubit<SignupState> {

  SignupCubit()
      : super(const SignupState());

  final storage =
      const FlutterSecureStorage();

  final service =
      OdooService(ApiConfig.baseUrl);

  void togglePassword() {

    emit(
      state.copyWith(
        obscurePassword:
            !state.obscurePassword,
      ),
    );
  }



  void toggleConfirmPassword() {

    emit(
      state.copyWith(
        obscureConfirmPassword:
            !state.obscureConfirmPassword,
      ),
    );
  }

  Future<void> signup({

    required String name,
    required String email,
    required String password,
    required String confirmPassword,

  }) async {

    // VALIDATION
    if (name.trim().isEmpty ||
        email.trim().isEmpty ||
        password.isEmpty) {

      emit(
        state.copyWith(
          status: SignupStatus.error,

          message:
              'Please fill all fields',
        ),
      );

      return;
    }

    // PASSWORD CHECK
    if (password != confirmPassword) {

      emit(
        state.copyWith(
          status: SignupStatus.error,

          message:
              'Passwords do not match',
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status: SignupStatus.loading,
      ),
    );

    try {

      print(
        'Signup Started => $email',
      );

      // SIGNUP API
      final signupResponse =
          await service.signup(

        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      print(
        "SIGNUP SUCCESS",
      );

      print(signupResponse);

      // AUTO LOGIN
      final loginResponse =
          await service.login(

        email: email,
        password: password,
      );

      print(
        "LOGIN SUCCESS",
      );

      print(loginResponse);

      // SAVE LOGIN SESSION
      await storage.write(
        key: "token",
        value: loginResponse.toString(),
      );

      await storage.write(
        key: "isLogin",
        value: "true",
      );

      await storage.write(
        key: "email",
        value: email,
      );

      emit(
        state.copyWith(

          status:
              SignupStatus.success,

          message:
              'Account created successfully',
        ),
      );

    } catch (e) {

      print(
        "SIGNUP ERROR",
      );

      print(e);

      emit(
        state.copyWith(

          status:
              SignupStatus.error,

          message:
              'Signup Failed',
        ),
      );
    }
  }
}
