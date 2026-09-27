import 'dart:convert';

class UpdateLocationRequestModel {
  final double latitude;
  final double longitude;

  UpdateLocationRequestModel({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UpdateLocationRequestModel.fromMap(Map<String, dynamic> map) {
    return UpdateLocationRequestModel(
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateLocationRequestModel.fromJson(String source) =>
      UpdateLocationRequestModel.fromMap(json.decode(source));
}
