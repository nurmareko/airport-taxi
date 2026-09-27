import 'dart:convert';

class UpdateLocationOrderanRequestModel {
  final double latitude;
  final double longitude;

  UpdateLocationOrderanRequestModel({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory UpdateLocationOrderanRequestModel.fromMap(Map<String, dynamic> map) {
    return UpdateLocationOrderanRequestModel(
      latitude: map['latitude'] ?? 0.0,
      longitude: map['longitude'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateLocationOrderanRequestModel.fromJson(String source) =>
      UpdateLocationOrderanRequestModel.fromMap(json.decode(source));
}
