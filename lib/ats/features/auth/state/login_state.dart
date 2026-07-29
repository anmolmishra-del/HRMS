import 'package:equatable/equatable.dart';

enum AtsLoginStatus { initial, loading, success, failure }

class AtsLoginState extends Equatable {
  final AtsLoginStatus status;
  final String? errorMessage;
  final String username;
  final String password;
  final bool rememberMe;
  final bool obscurePassword;
  final String? usernameError;
  final String? passwordError;

  const AtsLoginState({
    this.status = AtsLoginStatus.initial,
    this.errorMessage,
    this.username = '',
    this.password = '',
    this.rememberMe = true,
    this.obscurePassword = true,
    this.usernameError,
    this.passwordError,
  });

  AtsLoginState copyWith({
    AtsLoginStatus? status,
    String? errorMessage,
    String? username,
    String? password,
    bool? rememberMe,
    bool? obscurePassword,
    String? usernameError,
    String? passwordError,
  }) {
    return AtsLoginState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      username: username ?? this.username,
      password: password ?? this.password,
      rememberMe: rememberMe ?? this.rememberMe,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      usernameError: usernameError, // Allow null to clear error
      passwordError: passwordError, // Allow null to clear error
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        username,
        password,
        rememberMe,
        obscurePassword,
        usernameError,
        passwordError,
      ];
}
