class SendReviewResponseModel {
  int id;

  SendReviewResponseModel({
    required this.id,
  });

  factory SendReviewResponseModel.fromJson(Map<String, dynamic> json) {
    return SendReviewResponseModel(
      id: json["id"],
    );
  }

  static SendReviewResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return SendReviewResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };

  @override
  String toString() => 'SendReviewResponseModel(id: $id)';
}
