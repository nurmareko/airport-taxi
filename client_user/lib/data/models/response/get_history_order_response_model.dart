class GetHistoryOrderResponseModel {
  List<OrderData> data;

  GetHistoryOrderResponseModel({required this.data});

  factory GetHistoryOrderResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<OrderData> dataList = list.map((i) => OrderData.fromJson(i)).toList();
    return GetHistoryOrderResponseModel(data: dataList);
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => 'GetHistoryOrderResponseModel(data: $data)';
}

class OrderData {
  String id;
  double lat;
  double long;
  int customerId;
  int driverId;
  String rideId;
  int status;
  String cost;
  String farePerKm;
  int customerToAirportDistance;
  String createDatetime;
  String updateDatetime;
  Driver driver;
  Review? review; // Review can be null

  OrderData({
    required this.id,
    required this.lat,
    required this.long,
    required this.customerId,
    required this.driverId,
    required this.rideId,
    required this.status,
    required this.cost,
    required this.farePerKm,
    required this.customerToAirportDistance,
    required this.createDatetime,
    required this.updateDatetime,
    required this.driver,
    this.review,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] ?? '', // Default value if null
      lat: (json['lat'] ?? 0.0).toDouble(),
      long: (json['long'] ?? 0.0).toDouble(),
      customerId: json['customerId'] ?? 0,
      driverId: json['driverId'] ?? 0,
      rideId: json['rideId'] ?? '',
      status: json['status'] ?? 0,
      cost: json['cost'] ?? '',
      farePerKm: json['farePerKm'] ?? '',
      customerToAirportDistance: json['customerToAirportDistance'] ?? 0,
      createDatetime: json['createDatetime'] ?? '',
      updateDatetime: json['updateDatetime'] ?? '',
      driver: Driver.fromJson(json['driver']),
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "lat": lat,
        "long": long,
        "customerId": customerId,
        "driverId": driverId,
        "rideId": rideId,
        "status": status,
        "cost": cost,
        "farePerKm": farePerKm,
        "customerToAirportDistance": customerToAirportDistance,
        "createDatetime": createDatetime,
        "updateDatetime": updateDatetime,
        "driver": driver.toJson(),
        "review": review?.toJson(),
      };

  @override
  String toString() {
    return 'OrderData(id: $id, lat: $lat, long: $long, customerId: $customerId, driverId: $driverId, rideId: $rideId, status: $status, cost: $cost, farePerKm: $farePerKm, customerToAirportDistance: $customerToAirportDistance, createDatetime: $createDatetime, updateDatetime: $updateDatetime, driver: $driver, review: $review)';
  }
}

class Driver {
  final int id;
  final String name;
  final String licensePlate;
  final String photo;
  final double lat;
  final double long;

  Driver({
    required this.id,
    required this.name,
    required this.licensePlate,
    required this.photo,
    required this.lat,
    required this.long,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      licensePlate: json['licensePlate'],
      photo: json['photo'] ?? '',
      lat: (json['lat'] ?? 0.0).toDouble(),
      long: (json['long'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "licensePlate": licensePlate,
        "photo": photo,
        "lat": lat,
        "long": long,
      };

  @override
  String toString() {
    return 'Driver(id: $id, name: $name, licensePlate: $licensePlate, photo: $photo, lat: $lat, long: $long)';
  }
}

class Review {
  int id;
  String orderId;
  double driverRating;
  String driverReview;

  Review({
    required this.id,
    required this.orderId,
    required this.driverRating,
    required this.driverReview,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0,
      orderId: json['orderId'] ?? '',
      driverRating: (json['driverRating'] ?? 0.0).toDouble(),
      driverReview: json['driverReview'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "driverRating": driverRating,
        "driverReview": driverReview,
      };

  @override
  String toString() {
    return 'Review(id: $id, orderId: $orderId, driverRating: $driverRating, driverReview: $driverReview)';
  }
}
