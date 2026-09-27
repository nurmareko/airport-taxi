import 'dart:convert';

class ResetPasswordRequestModel {
  final String email;
  final String password;
  ResetPasswordRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  factory ResetPasswordRequestModel.fromMap(Map<String, dynamic> map) {
    return ResetPasswordRequestModel(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ResetPasswordRequestModel.fromJson(String source) =>
      ResetPasswordRequestModel.fromMap(json.decode(source));
}
