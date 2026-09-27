import 'dart:convert';

class ForgotPasswordRequestModel {
  final String email;
  
  ForgotPasswordRequestModel({
    required this.email,
  });


  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }

  factory ForgotPasswordRequestModel.fromMap(Map<String, dynamic> map) {
    return ForgotPasswordRequestModel(
      email: map['email'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ForgotPasswordRequestModel.fromJson(String source) => ForgotPasswordRequestModel.fromMap(json.decode(source));
}
