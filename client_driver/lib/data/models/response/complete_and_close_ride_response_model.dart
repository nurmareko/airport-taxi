class CompleteAndCloseRideResponseModel {
  int driverId;

  CompleteAndCloseRideResponseModel({
    required this.driverId,
  });

  factory CompleteAndCloseRideResponseModel.fromJson(
      Map<String, dynamic> json) {
    return CompleteAndCloseRideResponseModel(
      driverId: json["driverId"],
    );
  }

  static CompleteAndCloseRideResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return CompleteAndCloseRideResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
      };

  @override
  String toString() => 'CompleteAndCloseRideResponseModel(driverId: $driverId)';
}
