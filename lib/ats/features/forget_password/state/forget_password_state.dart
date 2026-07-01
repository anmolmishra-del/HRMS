enum ForgotPasswordStatus {
  initial,
  loading,
  success,
  error,
}

class ForgotPasswordState {
  final ForgotPasswordStatus status;
  final String message;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.message = '',
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? message,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
