enum AuthStatus { initial, loading, success, error }

class LoginState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final AuthStatus status;
  final String? errorMessage;

  LoginState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.status = AuthStatus.initial,
    this.errorMessage,
  });

  LoginState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    AuthStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError:
          emailError, 
      passwordError: passwordError,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
