class AuthModelLogin {
  final String token;

  AuthModelLogin({required this.token});

  factory AuthModelLogin.fromJson(Map<String, dynamic> json) {
    return AuthModelLogin(token: json['token']);
  }
}

class AuthModelError {
  final String message;

  AuthModelError({required this.message});

  factory AuthModelError.fromJson(Map<String, dynamic> json) {
    return AuthModelError(message: json['message']);
  }
}
