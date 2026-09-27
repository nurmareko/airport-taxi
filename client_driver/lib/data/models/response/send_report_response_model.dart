class SendReportResponseModel {
  int id;

  SendReportResponseModel({
    required this.id,
  });

  factory SendReportResponseModel.fromJson(Map<String, dynamic> json) {
    return SendReportResponseModel(
      id: json["id"],
    );
  }

  static SendReportResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return SendReportResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };

  @override
  String toString() => 'SendReportResponseModel(id: $id)';
}
