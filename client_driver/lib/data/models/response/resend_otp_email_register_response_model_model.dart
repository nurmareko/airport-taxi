class ResendOTPEmailRegisterResponseModel {
  String email;

  ResendOTPEmailRegisterResponseModel({
    required this.email,
  });

  factory ResendOTPEmailRegisterResponseModel.fromJson(
      Map<String, dynamic> json) {
    return ResendOTPEmailRegisterResponseModel(
      email: json["email"],
    );
  }

  static ResendOTPEmailRegisterResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return ResendOTPEmailRegisterResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() => 'ResendOTPEmailRegisterResponseModel(email: $email)';
}
