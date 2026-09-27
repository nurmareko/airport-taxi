import 'dart:convert';

class ResendOTPEmailForgotPasswordRequestModel {
  final String email;
  ResendOTPEmailForgotPasswordRequestModel({
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }

  factory ResendOTPEmailForgotPasswordRequestModel.fromMap(
      Map<String, dynamic> map) {
    return ResendOTPEmailForgotPasswordRequestModel(
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ResendOTPEmailForgotPasswordRequestModel.fromJson(String source) =>
      ResendOTPEmailForgotPasswordRequestModel.fromMap(json.decode(source));
}
