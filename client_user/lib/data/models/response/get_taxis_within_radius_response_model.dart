class CustomerLocation {
  final double lat;
  final double long;
  final String address;

  CustomerLocation({
    required this.lat,
    required this.long,
    required this.address,
  });

  factory CustomerLocation.fromJson(Map<String, dynamic> json) {
    return CustomerLocation(
      lat: json['lat'],
      long: json['long'],
      address: json['address'],
    );
  }
}

class DriverInfo {
  final int id;
  final String name;
  final String licensePlate;
  final String photo;
  final double lat;
  final double long;
  final double averageRating; // Tambahkan averageRating

  DriverInfo({
    required this.id,
    required this.name,
    required this.licensePlate,
    required this.photo,
    required this.lat,
    required this.long,
    required this.averageRating, // Tambahkan averageRating ke konstruktor
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: json['id'],
      name: json['name'],
      licensePlate: json['licensePlate'],
      photo: json['photo'],
      lat: (json['lat'] ?? 0.0).toDouble(),
      long: (json['long'] ?? 0.0).toDouble(),
      averageRating: (json['averageRating'] ?? 0.0)
          .toDouble(), // Tambahkan averageRating ke fromJson
    );
  }
}

class Ride {
  final String id; // Changed from int to String
  final double lat;
  final double long;
  final int rideStatus;
  final int pickupRadius;
  final DriverInfo driverInfo;
  final Map<String, dynamic> distances;
  final Map<String, dynamic> durations;
  final String estimatedCost;
  final String createDateTime;
  final String updateDateTime;

  Ride({
    required this.id, // String data type
    required this.lat,
    required this.long,
    required this.rideStatus,
    required this.pickupRadius,
    required this.driverInfo,
    required this.distances,
    required this.durations,
    required this.estimatedCost,
    required this.createDateTime,
    required this.updateDateTime,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'], // Ensure it's parsed as a String
      lat: json['lat'],
      long: json['long'],
      rideStatus: json['rideStatus'],
      pickupRadius: json['pickupRadius'],
      driverInfo: DriverInfo.fromJson(json['driverInfo']),
      distances: json['distances'],
      durations: json['durations'],
      estimatedCost: json['estimatedCost'],
      createDateTime: json['createDateTime'],
      updateDateTime: json['updateDateTime'],
    );
  }
}

class GetTaxisWithinRadiusResponseModel {
  final CustomerLocation customerLocation;
  final int availableRidesCount;
  final List<Ride> rides;

  GetTaxisWithinRadiusResponseModel({
    required this.customerLocation,
    required this.availableRidesCount,
    required this.rides,
  });

  factory GetTaxisWithinRadiusResponseModel.fromJson(
      Map<String, dynamic> json) {
    return GetTaxisWithinRadiusResponseModel(
      customerLocation: CustomerLocation.fromJson(json['customerLocation']),
      availableRidesCount: json['availableRidesCount'],
      rides: List<Ride>.from(json['rides'].map((x) => Ride.fromJson(x))),
    );
  }
}
