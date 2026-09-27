class ChangePasswordResponseModel {
  String email;

  ChangePasswordResponseModel({
    required this.email,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      email: json["email"],
    );
  }

  static ChangePasswordResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return ChangePasswordResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
      };

  @override
  String toString() => 'ChangePasswordResponseModel(email: $email)';
}
