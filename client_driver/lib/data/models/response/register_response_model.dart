class RegisterResponseModel {
  String email;

  RegisterResponseModel({
    required this.email,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      email: json["email"],
    );
  }

  static RegisterResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return RegisterResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() => 'RegisterResponseModel(email: $email)';
}
