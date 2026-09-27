import 'dart:convert';

class GetCurrentRideResponseModel {
  String id; // Changed to String
  double lat;
  double long;
  int rideStatus;
  int pickupRadius;
  String createDatetime; // New field for creation date
  String updateDatetime; // New field for update date

  GetCurrentRideResponseModel({
    required this.id,
    required this.lat,
    required this.long,
    required this.rideStatus,
    required this.pickupRadius,
    required this.createDatetime, // Include in the constructor
    required this.updateDatetime, // Include in the constructor
  });

  factory GetCurrentRideResponseModel.fromMap(Map<String, dynamic> map) {
    return GetCurrentRideResponseModel(
      id: map['id'] ?? '', // Changed to String
      lat: map['lat']?.toDouble() ?? 0.0,
      long: map['long']?.toDouble() ?? 0.0,
      rideStatus: map['rideStatus']?.toInt() ?? 0,
      pickupRadius: map['pickupRadius']?.toInt() ?? 0,
      createDatetime: map['createDatetime'] ?? '', // Initialize new field
      updateDatetime: map['updateDatetime'] ?? '', // Initialize new field
    );
  }

  factory GetCurrentRideResponseModel.fromResponseData(
      Map<String, dynamic> responseData) {
    return GetCurrentRideResponseModel.fromMap(responseData['data']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Changed to String
      'lat': lat,
      'long': long,
      'rideStatus': rideStatus,
      'pickupRadius': pickupRadius,
      'createDatetime': createDatetime, // Include in the map
      'updateDatetime': updateDatetime, // Include in the map
    };
  }

  String toJson() => json.encode(toMap());

  factory GetCurrentRideResponseModel.fromJson(String source) =>
      GetCurrentRideResponseModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetCurrentRideResponseModel(id: $id, lat: $lat, long: $long, rideStatus: $rideStatus, pickupRadius: $pickupRadius, createDatetime: $createDatetime, updateDatetime: $updateDatetime)';
}
