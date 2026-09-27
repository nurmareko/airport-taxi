import 'dart:convert';

class AddRideRequestModel {
  final double lat;
  final double long;
  final int pickupRadius;
  AddRideRequestModel({
    required this.lat,
    required this.long,
    required this.pickupRadius,
  });

  Map<String, dynamic> toMap() {
    return {
      'lat': lat,
      'long': long,
      'pickupRadius': pickupRadius,
    };
  }

  factory AddRideRequestModel.fromMap(Map<String, dynamic> map) {
    return AddRideRequestModel(
      lat: map['lat']?.toDouble() ?? 0.0,
      long: map['long']?.toDouble() ?? 0.0,
      pickupRadius: map['pickupRadius']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddRideRequestModel.fromJson(String source) => AddRideRequestModel.fromMap(json.decode(source));
}
