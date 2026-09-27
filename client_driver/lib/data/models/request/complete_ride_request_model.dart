import 'dart:convert';

class CompleteRideRequestModel {
  final String rideId;

  CompleteRideRequestModel({
    required this.rideId,
  });

  Map<String, dynamic> toMap() {
    return {
      'rideId': rideId,
    };
  }

  factory CompleteRideRequestModel.fromMap(Map<String, dynamic> map) {
    return CompleteRideRequestModel(
      rideId: map['rideId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CompleteRideRequestModel.fromJson(String source) =>
      CompleteRideRequestModel.fromMap(json.decode(source));
}
