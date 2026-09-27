class DriverInfo {
  int id;
  String noMembership;
  String licensePlate;
  String name;
  String phoneNumber;
  String photo;
  double lat;
  double long;
  double averageRating; // Tambahkan averageRating

  DriverInfo({
    required this.id,
    required this.noMembership,
    required this.licensePlate,
    required this.name,
    required this.phoneNumber,
    required this.photo,
    required this.lat,
    required this.long,
    required this.averageRating, // Tambahkan averageRating ke konstruktor
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json["id"] ?? 0,
      noMembership: json["noMembership"] ?? '',
      licensePlate: json["licensePlate"] ?? '',
      name: json["name"] ?? '',
      phoneNumber: json["phoneNumber"] ?? '',
      photo: json["photo"] ?? '',
      lat: (json["lat"] ?? 0.0).toDouble(),
      long: (json["long"] ?? 0.0).toDouble(),
      averageRating: (json["averageRating"] ?? 0.0)
          .toDouble(), // Tambahkan averageRating ke fromJson
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "noMembership": noMembership,
        "licensePlate": licensePlate,
        "name": name,
        "phoneNumber": phoneNumber,
        "photo": photo,
        "lat": lat,
        "long": long,
        "averageRating": averageRating, // Tambahkan averageRating ke toJson
      };
}

class RideInfo {
  String id; // Changed to String
  int driverId;
  double lat;
  double long;
  int pickupRadius;
  int rideStatus; // Added rideStatus

  RideInfo({
    required this.id,
    required this.driverId,
    required this.lat,
    required this.long,
    required this.pickupRadius,
    required this.rideStatus, // Added rideStatus in constructor
  });

  factory RideInfo.fromJson(Map<String, dynamic> json) {
    return RideInfo(
      id: json["id"] ?? '',
      driverId: json["driverId"] ?? 0,
      lat: (json["lat"] ?? 0.0).toDouble(),
      long: (json["long"] ?? 0.0).toDouble(),
      pickupRadius: json["pickupRadius"] ?? 0,
      rideStatus: json["rideStatus"] ?? 0, // Added rideStatus in fromJson
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "driverId": driverId,
        "lat": lat,
        "long": long,
        "pickupRadius": pickupRadius,
        "rideStatus": rideStatus, // Added rideStatus in toJson
      };
}

class GetCurrentOrderResponseModel {
  String id; // Changed to String
  double lat;
  double long;
  int status;
  int customerToAirportDistance;
  String farePerKm;
  String cost;
  String rideId; // Changed to String
  int customerId;
  DriverInfo driver;
  String estimationDuration;
  String estimationDistance;
  RideInfo rideInfo;

  GetCurrentOrderResponseModel({
    required this.id,
    required this.lat,
    required this.long,
    required this.status,
    required this.customerToAirportDistance,
    required this.farePerKm,
    required this.cost,
    required this.rideId,
    required this.customerId,
    required this.driver,
    required this.estimationDuration,
    required this.estimationDistance,
    required this.rideInfo,
  });

  factory GetCurrentOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCurrentOrderResponseModel(
      id: json["id"] ?? '',
      lat: (json["lat"] ?? 0.0).toDouble(),
      long: (json["long"] ?? 0.0).toDouble(),
      status: json["status"] ?? 0,
      customerToAirportDistance: json["customerToAirportDistance"] ?? 0,
      farePerKm: json["farePerKm"] ?? '',
      cost: json["cost"] ?? '',
      rideId: json["rideId"] ?? '',
      customerId: json["customerId"] ?? 0,
      driver: DriverInfo.fromJson(json["driver"]),
      estimationDuration: json["estimationDuration"] ?? '',
      estimationDistance: json["estimationDistance"] ?? '',
      rideInfo: RideInfo.fromJson(json["rideInfo"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "lat": lat,
        "long": long,
        "status": status,
        "customerToAirportDistance": customerToAirportDistance,
        "farePerKm": farePerKm,
        "cost": cost,
        "rideId": rideId,
        "customerId": customerId,
        "driver": driver.toJson(),
        "estimationDuration": estimationDuration,
        "estimationDistance": estimationDistance,
        "rideInfo": rideInfo.toJson(),
      };

  @override
  String toString() =>
      'GetCurrentOrderResponseModel(id: $id, lat: $lat, long: $long, status: $status, customerToAirportDistance: $customerToAirportDistance, farePerKm: $farePerKm, cost: $cost, rideId: $rideId, customerId: $customerId, driver: $driver, estimationDuration: $estimationDuration, estimationDistance: $estimationDistance, rideInfo: $rideInfo)';
}
