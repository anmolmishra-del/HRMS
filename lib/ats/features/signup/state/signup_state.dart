enum SignupStatus {
  initial,
  loading,
  success,
  error,
}

class SignupState {

  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final SignupStatus status;
  final String message;

  const SignupState({
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.status = SignupStatus.initial,
    this.message = '',
  });

  SignupState copyWith({
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    SignupStatus? status,
    String? message,
  }) {
    return SignupState(
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
        obscurePassword,
        obscureConfirmPassword,
        status,
        message,
      ];
}
