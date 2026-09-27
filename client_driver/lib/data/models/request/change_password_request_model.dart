import 'dart:convert';

class ChangePasswordRequestModel {
  final String oldPassword;
  final String newPassword;
  ChangePasswordRequestModel({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };
  }

  factory ChangePasswordRequestModel.fromMap(Map<String, dynamic> map) {
    return ChangePasswordRequestModel(
      oldPassword: map['oldPassword'] ?? '',
      newPassword: map['newPassword'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChangePasswordRequestModel.fromJson(String source) =>
      ChangePasswordRequestModel.fromMap(json.decode(source));
}
