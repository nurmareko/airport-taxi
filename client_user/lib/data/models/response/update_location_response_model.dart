class UpdateLocationResponseModel {
  String email;

  UpdateLocationResponseModel({
    required this.email,
  });

  factory UpdateLocationResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateLocationResponseModel(
      email: json["email"],
    );
  }

  static UpdateLocationResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return UpdateLocationResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() => 'UpdateLocationResponseModel(email: $email)';
}
