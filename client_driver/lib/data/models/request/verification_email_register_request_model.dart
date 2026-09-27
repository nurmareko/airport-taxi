import 'dart:convert';

class VerificationEmailRegisterRequestModel {
  final String email;
  final String otp;
  VerificationEmailRegisterRequestModel(
      {required this.otp, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'otp': otp,
    };
  }

  factory VerificationEmailRegisterRequestModel.fromMap(
      Map<String, dynamic> map) {
    return VerificationEmailRegisterRequestModel(
      email: map['email'] ?? '',
      otp: map['otp'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VerificationEmailRegisterRequestModel.fromJson(String source) =>
      VerificationEmailRegisterRequestModel.fromMap(json.decode(source));
}
