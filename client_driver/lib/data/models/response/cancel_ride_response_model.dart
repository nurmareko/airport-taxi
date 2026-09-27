class CancelRideResponseModel {
  int driverId;

  CancelRideResponseModel({
    required this.driverId,
  });

  factory CancelRideResponseModel.fromJson(Map<String, dynamic> json) {
    return CancelRideResponseModel(
      driverId: json["driverId"],
    );
  }

  static CancelRideResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return CancelRideResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
      };

  @override
  String toString() => 'CancelRideResponseModel(driverId: $driverId)';
}
