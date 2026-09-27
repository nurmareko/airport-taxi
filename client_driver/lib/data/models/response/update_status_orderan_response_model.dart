class UpdateStatusOrderanResponseModel {
  int driverId;

  UpdateStatusOrderanResponseModel({
    required this.driverId,
  });

  factory UpdateStatusOrderanResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateStatusOrderanResponseModel(
      driverId: json["driverId"],
    );
  }

  static UpdateStatusOrderanResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return UpdateStatusOrderanResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
      };

  @override
  String toString() => 'UpdateStatusOrderanResponseModel(driverId: $driverId)';
}
