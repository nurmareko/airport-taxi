class AcceptOrderanResponseModel {
  int driverId;

  AcceptOrderanResponseModel({
    required this.driverId,
  });

  factory AcceptOrderanResponseModel.fromJson(Map<String, dynamic> json) {
    return AcceptOrderanResponseModel(
      driverId: json["driverId"],
    );
  }

  static AcceptOrderanResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return AcceptOrderanResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
      };

  @override
  String toString() => 'AcceptOrderanResponseModel(driverId: $driverId)';
}
