class LoginModel {
  final String email;
  final String password;
  final bool rememberMe;

  LoginModel({
    required this.email,
    required this.password,
    required this.rememberMe,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,

    };
  }
}
