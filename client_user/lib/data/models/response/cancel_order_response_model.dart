class CancelOrderResponseModel {
  String id; // Changed from int to String

  CancelOrderResponseModel({
    required this.id,
  });

  factory CancelOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return CancelOrderResponseModel(
      id: json["id"], // No conversion needed as it's now a String
    );
  }

  static CancelOrderResponseModel fromResponseData(Map<String, dynamic> responseData) {
    return CancelOrderResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };

  @override
  String toString() => 'CancelOrderResponseModel(id: $id)';
}
