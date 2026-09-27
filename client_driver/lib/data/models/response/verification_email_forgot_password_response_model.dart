class VerificationEmailForgotPasswordResponseModel {
  String email;

  VerificationEmailForgotPasswordResponseModel({
    required this.email,
  });

  factory VerificationEmailForgotPasswordResponseModel.fromJson(
      Map<String, dynamic> json) {
    return VerificationEmailForgotPasswordResponseModel(
      email: json["email"],
    );
  }

  static VerificationEmailForgotPasswordResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return VerificationEmailForgotPasswordResponseModel.fromJson(
        responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() =>
      'VerificationEmailForgotPasswordResponseModel(email: $email)';
}
