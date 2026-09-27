class ResendOTPEmailForgotPasswordResponseModel {
  String email;

  ResendOTPEmailForgotPasswordResponseModel({
    required this.email,
  });

  factory ResendOTPEmailForgotPasswordResponseModel.fromJson(
      Map<String, dynamic> json) {
    return ResendOTPEmailForgotPasswordResponseModel(
      email: json["email"],
    );
  }

  static ResendOTPEmailForgotPasswordResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return ResendOTPEmailForgotPasswordResponseModel.fromJson(
        responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() =>
      'ResendOTPEmailForgotPasswordResponseModel(email: $email)';
}
