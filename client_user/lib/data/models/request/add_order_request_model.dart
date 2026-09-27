import 'dart:convert';

class AddOrderRequestModel {
  final String rideId; // Changed from int to String
  final double latitude;
  final double longitude;

  AddOrderRequestModel({
    required this.rideId,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory AddOrderRequestModel.fromMap(Map<String, dynamic> map) {
    return AddOrderRequestModel(
      rideId: map['rideId'] ?? '', // Updated to handle String type
      latitude: map['latitude']?.toDouble() ?? 0.0,
      longitude: map['longitude']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddOrderRequestModel.fromJson(String source) =>
      AddOrderRequestModel.fromMap(json.decode(source));
}
