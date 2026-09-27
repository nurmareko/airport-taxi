import 'dart:convert';

class UpdateDeviceTokenRequestModel {
  final String deviceToken;

  UpdateDeviceTokenRequestModel({
    required this.deviceToken,
  });

  Map<String, dynamic> toMap() {
    return {
      'deviceToken': deviceToken,
    };
  }

  factory UpdateDeviceTokenRequestModel.fromMap(Map<String, dynamic> map) {
    return UpdateDeviceTokenRequestModel(
      deviceToken: map['deviceToken'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateDeviceTokenRequestModel.fromJson(String source) =>
      UpdateDeviceTokenRequestModel.fromMap(json.decode(source));
}
