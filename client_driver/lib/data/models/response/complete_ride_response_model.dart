class CompleteRideResponseModel {
  int driverId;

  CompleteRideResponseModel({
    required this.driverId,
  });

  factory CompleteRideResponseModel.fromJson(Map<String, dynamic> json) {
    return CompleteRideResponseModel(
      driverId: json["driverId"],
    );
  }

  static CompleteRideResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return CompleteRideResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
      };

  @override
  String toString() => 'CompleteRideResponseModel(driverId: $driverId)';
}
