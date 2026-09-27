import 'dart:convert';

class CompleteAndCloseRideRequestModel {
  final String rideId;

  CompleteAndCloseRideRequestModel({
    required this.rideId,
  });

  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
    };
  }

  factory CompleteAndCloseRideRequestModel.fromMap(Map<String, dynamic> map) {
    return CompleteAndCloseRideRequestModel(
      rideId: map['rideId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CompleteAndCloseRideRequestModel.fromJson(String source) =>
      CompleteAndCloseRideRequestModel.fromMap(json.decode(source));
}
