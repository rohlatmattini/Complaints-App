class SignUpModel {
  final String userName;
  final String phoneNumber;
  final String email;
  final String password;

  SignUpModel({
    required this.userName,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': userName,
      'phone_number': phoneNumber,
      'email': email,
      'password': password,
      'password_confirmation': password,
    };
  }
}