class ForgotPasswordResponseModel {
  String email;

  ForgotPasswordResponseModel({
    required this.email,
  });

  factory ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponseModel(
      email: json["email"],
    );
  }

  static ForgotPasswordResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return ForgotPasswordResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() => 'ForgotPasswordResponseModel(email: $email)';
}
