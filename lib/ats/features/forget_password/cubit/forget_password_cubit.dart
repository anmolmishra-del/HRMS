import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/ats/features/forget_password/state/forget_password_state.dart';

class ForgotPasswordCubit
    extends Cubit<ForgotPasswordState> {

  ForgotPasswordCubit()
      : super(const ForgotPasswordState());

  Future<void> sendResetLink({
    required String email,
  }) async {

    if (email.isEmpty) {

      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          message: "Please enter email",
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status: ForgotPasswordStatus.loading,
      ),
    );

    await Future.delayed(
      const Duration(seconds: 2),
    );

    /// API CALL HERE

    emit(
      state.copyWith(
        status: ForgotPasswordStatus.success,
        message:
            "Password reset link sent successfully",
      ),
    );
  }
}
