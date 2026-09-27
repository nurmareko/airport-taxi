import 'dart:convert';

class CancelRideRequestModel {
  final String rideId;

  CancelRideRequestModel({
    required this.rideId,
  });

  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
    };
  }

  factory CancelRideRequestModel.fromMap(Map<String, dynamic> map) {
    return CancelRideRequestModel(
      rideId: map['rideId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CancelRideRequestModel.fromJson(String source) =>
      CancelRideRequestModel.fromMap(json.decode(source));
}
