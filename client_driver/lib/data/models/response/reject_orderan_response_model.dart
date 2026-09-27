class RejectOrderanResponseModel {
  int driverId;

  RejectOrderanResponseModel({
    required this.driverId,
  });

  factory RejectOrderanResponseModel.fromJson(Map<String, dynamic> json) {
    return RejectOrderanResponseModel(
      driverId: json["driverId"],
    );
  }

  static RejectOrderanResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return RejectOrderanResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "driverId": driverId,
      };

  @override
  String toString() => 'RejectOrderanResponseModel(driverId: $driverId)';
}
