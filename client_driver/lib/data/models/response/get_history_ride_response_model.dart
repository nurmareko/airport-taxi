class GetHistoryRideResponseModel {
  List<RideData> data;

  GetHistoryRideResponseModel({required this.data});

  factory GetHistoryRideResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List;
    List<RideData> dataList = list.map((i) => RideData.fromJson(i)).toList();

    return GetHistoryRideResponseModel(data: dataList);
  }

  Map<String, dynamic> toJson() => {
        "data": data.map((e) => e.toJson()).toList(),
      };

  @override
  String toString() => 'GetHistoryRideResponseModel(data: $data)';
}

class RideData {
  String id;  // Changed from int to String
  double lat;
  double long;
  int pickupRadius;
  int rideStatus;
  String createDatetime;
  String updateDatetime;

  RideData({
    required this.id,
    required this.lat,
    required this.long,
    required this.pickupRadius,
    required this.rideStatus,
    required this.createDatetime,
    required this.updateDatetime,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      id: json['id'] ?? '', // Provide default value if null
      lat: (json['lat'] ?? 0.0).toDouble(),
      long: (json['long'] ?? 0.0).toDouble(),
      pickupRadius: json['pickupRadius'] ?? 0,
      rideStatus: json['rideStatus'] ?? 0,
      createDatetime: json['createDatetime'] ?? '',
      updateDatetime: json['updateDatetime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "lat": lat,
        "long": long,
        "pickupRadius": pickupRadius,
        "rideStatus": rideStatus,
        "createDatetime": createDatetime,
        "updateDatetime": updateDatetime,
      };

  @override
  String toString() =>
      'RideData(id: $id, lat: $lat, long: $long, pickupRadius: $pickupRadius, rideStatus: $rideStatus, createDatetime: $createDatetime, updateDatetime: $updateDatetime)';
}
