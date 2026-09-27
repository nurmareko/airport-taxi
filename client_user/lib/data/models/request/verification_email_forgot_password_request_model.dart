import 'dart:convert';

class VerificationEmailForgotPasswordRequestModel {
  final String email;
  final String otp;
  VerificationEmailForgotPasswordRequestModel({required this.otp, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'otp': otp,
    };
  }

  factory VerificationEmailForgotPasswordRequestModel.fromMap(Map<String, dynamic> map) {
    return VerificationEmailForgotPasswordRequestModel(
      email: map['email'] ?? '',
      otp: map['otp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VerificationEmailForgotPasswordRequestModel.fromJson(String source) =>
      VerificationEmailForgotPasswordRequestModel.fromMap(json.decode(source));
}
