import 'dart:convert';

class Customer {
  int id;
  String email;
  String name;
  String phoneNumber;
  String photo;
  double averageRating; // Tambahkan properti averageRating

  Customer({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.photo,
    required this.averageRating, // Tambahkan averageRating ke dalam constructor
  });

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      id: map['id']?.toInt() ?? 0,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      photo: map['photo'] ?? '',
      averageRating:
          map['averageRating']?.toDouble() ?? 0.0, // Konversi averageRating
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'photo': photo,
      'averageRating': averageRating, // Tambahkan averageRating ke dalam toMap
    };
  }
}

class Ride {
  String id; // Changed to String
  double lat;
  double long;
  int rideStatus;
  int pickupRadius;
  int driverId; // Changed to int

  Ride({
    required this.id,
    required this.lat,
    required this.long,
    required this.rideStatus,
    required this.pickupRadius,
    required this.driverId, // Changed to int
  });

  factory Ride.fromMap(Map<String, dynamic> map) {
    return Ride(
      id: map['id'] ?? '',
      lat: map['lat']?.toDouble() ?? 0.0,
      long: map['long']?.toDouble() ?? 0.0,
      rideStatus: map['rideStatus']?.toInt() ?? 0,
      pickupRadius: map['pickupRadius']?.toInt() ?? 0,
      driverId: map['driverId']?.toInt() ?? 0, // Changed to int
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'lat': lat,
      'long': long,
      'rideStatus': rideStatus,
      'pickupRadius': pickupRadius,
      'driverId': driverId, // Changed to int
    };
  }
}

class GetCurrentOrderanResponseModel {
  String id; // Changed to String
  double lat;
  double long;
  int status;
  int customerToAirportDistance;
  String farePerKm;
  String cost;
  String rideId; // Changed to String
  int customerId;
  int driverId;
  Customer customer;
  Ride ride;

  GetCurrentOrderanResponseModel({
    required this.id,
    required this.lat,
    required this.long,
    required this.status,
    required this.customerToAirportDistance,
    required this.farePerKm,
    required this.cost,
    required this.rideId, // Changed to String
    required this.customerId,
    required this.driverId,
    required this.customer,
    required this.ride,
  });

  factory GetCurrentOrderanResponseModel.fromMap(Map<String, dynamic> map) {
    return GetCurrentOrderanResponseModel(
      id: map['id'] ?? '', // Changed to String
      lat: map['lat']?.toDouble() ?? 0.0,
      long: map['long']?.toDouble() ?? 0.0,
      status: map['status']?.toInt() ?? 0,
      customerToAirportDistance: map['customerToAirportDistance']?.toInt() ?? 0,
      farePerKm: map['farePerKm'] ?? '',
      cost: map['cost'] ?? '',
      rideId: map['rideId'] ?? '', // Changed to String
      customerId: map['customerId']?.toInt() ?? 0,
      driverId: map['driverId']?.toInt() ?? 0,
      customer: Customer.fromMap(map['customer']),
      ride: Ride.fromMap(map['ride']),
    );
  }

  factory GetCurrentOrderanResponseModel.fromResponseData(
      Map<String, dynamic> responseData) {
    return GetCurrentOrderanResponseModel.fromMap(responseData['data']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id, // Changed to String
      'lat': lat,
      'long': long,
      'status': status,
      'customerToAirportDistance': customerToAirportDistance,
      'farePerKm': farePerKm,
      'cost': cost,
      'rideId': rideId, // Changed to String
      'customerId': customerId,
      'driverId': driverId,
      'customer': customer.toMap(),
      'ride': ride.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  factory GetCurrentOrderanResponseModel.fromJson(String source) =>
      GetCurrentOrderanResponseModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'GetCurrentOrderanResponseModel(id: $id, lat: $lat, long: $long, status: $status, customerToAirportDistance: $customerToAirportDistance, farePerKm: $farePerKm, cost: $cost, rideId: $rideId, customerId: $customerId, driverId: $driverId, customer: $customer, ride: $ride)';
}
