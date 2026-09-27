import 'dart:convert';

class RegisterRequestModel {
  final String email;
  final String name;
  final String noMembership;
  final String licensePlate;
  final String phoneNumber;
  final String password;
  RegisterRequestModel({
    required this.email,
    required this.name,
    required this.noMembership,
    required this.licensePlate,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'noMembership': noMembership,
      'licensePlate': licensePlate,
      'phoneNumber': phoneNumber,
      'password': password,
    };
  }

  factory RegisterRequestModel.fromMap(Map<String, dynamic> map) {
    return RegisterRequestModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      noMembership: map['noMembership'] ?? '',
      licensePlate: map['licensePlate'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RegisterRequestModel.fromJson(String source) =>
      RegisterRequestModel.fromMap(json.decode(source));
}
