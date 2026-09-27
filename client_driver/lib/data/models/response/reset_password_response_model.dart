class ResetPasswordResponseModel {
  String email;

  ResetPasswordResponseModel({
    required this.email,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      email: json["email"],
    );
  }

  static ResetPasswordResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return ResetPasswordResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() => 'ResetPasswordResponseModel(email: $email)';
}
