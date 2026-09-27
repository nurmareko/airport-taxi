class AddRideResponseModel {
  int driverId;

  AddRideResponseModel({
    required this.driverId,
  });

  factory AddRideResponseModel.fromJson(Map<String, dynamic> json) {
    return AddRideResponseModel(
      driverId: json["driverId"],
    );
  }

  static AddRideResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return AddRideResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
      };

  @override
  String toString() => 'AddRideResponseModel(driverId: $driverId)';
}
