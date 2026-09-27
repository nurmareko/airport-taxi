class GetHistoryOrderanResponseModel {
  List<OrderData> data;

  GetHistoryOrderanResponseModel({required this.data});

  factory GetHistoryOrderanResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<OrderData> dataList = list.map((i) => OrderData.fromJson(i)).toList();

    return GetHistoryOrderanResponseModel(data: dataList);
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => 'GetHistoryOrderanResponseModel(data: $data)';
}

class OrderData {
  String id; // Changed from int to String
  double lat;
  double long;
  int customerId;
  int driverId;
  String rideId; // Changed from int to String
  int status;
  String cost;
  String farePerKm;
  int customerToAirportDistance;
  String createDatetime;
  String updateDatetime;
  Customer customer;
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
    required this.customer,
    this.review,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'] ?? '', // Provide default value if null
      lat: (json['lat'] ?? 0.0).toDouble(),
      long: (json['long'] ?? 0.0).toDouble(),
      customerId: json['customerId'] ?? 0,
      driverId: json['driverId'] ?? 0,
      rideId: json['rideId'] ?? '', // Provide default value if null
      status: json['status'] ?? 0,
      cost: json['cost'] ?? '',
      farePerKm: json['farePerKm'] ?? '',
      customerToAirportDistance: json['customerToAirportDistance'] ?? 0,
      createDatetime: json['createDatetime'] ?? '',
      updateDatetime: json['updateDatetime'] ?? '',
      customer: Customer.fromJson(json['customer']),
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
        "customer": customer.toJson(),
        "review": review?.toJson(), // Use null-aware operator
      };

  @override
  String toString() {
    return 'OrderData(id: $id, lat: $lat, long: $long, customerId: $customerId, driverId: $driverId, rideId: $rideId, status: $status, cost: $cost, farePerKm: $farePerKm, customerToAirportDistance: $customerToAirportDistance, createDatetime: $createDatetime, updateDatetime: $updateDatetime, customer: $customer, review: $review)';
  }
}

class Customer {
  int id;
  String name;
  String phoneNumber;
  String photo;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.photo,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? 0, // Provide default value if null
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      photo: json['photo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phoneNumber": phoneNumber,
        "photo": photo,
      };

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, phoneNumber: $phoneNumber, photo: $photo)';
  }
}

class Review {
  int id; // Changed from String to int
  String orderId; // Remains String
  double customerRating;
  String customerReview;

  Review({
    required this.id,
    required this.orderId,
    required this.customerRating,
    required this.customerReview,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? 0, // Provide default value if null
      orderId: json['orderId'] ?? '', // Provide default value if null
      customerRating: (json['customerRating'] ?? 0.0)
          .toDouble(), // Convert to double and provide default
      customerReview: json['customerReview'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderId": orderId,
        "customerRating": customerRating,
        "customerReview": customerReview,
      };

  @override
  String toString() {
    return 'Review(id: $id, orderId: $orderId, customerRating: $customerRating, customerReview: $customerReview)';
  }
}
