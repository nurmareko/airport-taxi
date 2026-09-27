class UpdateDriverResponseModel {
  String email;

  UpdateDriverResponseModel({
    required this.email,
  });

  factory UpdateDriverResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateDriverResponseModel(
      email: json["email"],
    );
  }

  static UpdateDriverResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return UpdateDriverResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() => 'UpdateDriverResponseModel(email: $email)';
}
