class SendMessageResponseModel {
  int id;

  SendMessageResponseModel({
    required this.id,
  });

  factory SendMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return SendMessageResponseModel(
      id: json["id"],
    );
  }

  static SendMessageResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return SendMessageResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };

  @override
  String toString() => 'SendMessageResponseModel(id: $id)';
}
