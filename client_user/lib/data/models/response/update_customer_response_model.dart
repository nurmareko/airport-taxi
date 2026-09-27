class UpdateCustomerResponseModel {
  String email;

  UpdateCustomerResponseModel({
    required this.email,
  });

  factory UpdateCustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateCustomerResponseModel(
      email: json["email"],
    );
  }

  static UpdateCustomerResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return UpdateCustomerResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() => 'UpdateCustomerResponseModel(email: $email)';
}
