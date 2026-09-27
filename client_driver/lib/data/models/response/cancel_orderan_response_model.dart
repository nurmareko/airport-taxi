class CancelOrderanResponseModel {
  int driverId;

  CancelOrderanResponseModel({
    required this.driverId,
  });

  factory CancelOrderanResponseModel.fromJson(Map<String, dynamic> json) {
    return CancelOrderanResponseModel(
      driverId: json["driverId"],
    );
  }

  static CancelOrderanResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return CancelOrderanResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
      };

  @override
  String toString() => 'CancelOrderanResponseModel(driverId: $driverId)';
}
