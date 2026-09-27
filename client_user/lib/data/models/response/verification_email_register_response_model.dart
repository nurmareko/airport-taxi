class VerificationEmailRegisterResponseModel {
  String email;

  VerificationEmailRegisterResponseModel({
    required this.email,
  });

  factory VerificationEmailRegisterResponseModel.fromJson(
      Map<String, dynamic> json) {
    return VerificationEmailRegisterResponseModel(
      email: json["email"],
    );
  }

  static VerificationEmailRegisterResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return VerificationEmailRegisterResponseModel.fromJson(
        responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() => 'VerificationEmailRegisterResponseModel(email: $email)';
}
