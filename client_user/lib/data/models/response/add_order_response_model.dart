class AddOrderResponseModel {
  String id; // Changed from int to String

  AddOrderResponseModel({
    required this.id,
  });

  factory AddOrderResponseModel.fromJson(Map<String, dynamic> json) {
    return AddOrderResponseModel(
      id: json["id"], // No conversion needed as it's now a String
    );
  }

  static AddOrderResponseModel fromResponseData(Map<String, dynamic> responseData) {
    return AddOrderResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
      };

  @override
  String toString() => 'AddOrderResponseModel(id: $id)';
}
