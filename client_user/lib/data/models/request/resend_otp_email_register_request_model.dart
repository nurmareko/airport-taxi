import 'dart:convert';

class ResendOTPEmailRegisterRequestModel {
  final String email;
  ResendOTPEmailRegisterRequestModel({
    required this.email,
  });
  

  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }

  factory ResendOTPEmailRegisterRequestModel.fromMap(Map<String, dynamic> map) {
    return ResendOTPEmailRegisterRequestModel(
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ResendOTPEmailRegisterRequestModel.fromJson(String source) => ResendOTPEmailRegisterRequestModel.fromMap(json.decode(source));
}
