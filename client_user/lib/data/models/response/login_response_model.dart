class LoginResponseModel {
  String token;

  LoginResponseModel({
    required this.token,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json["token"],
    );
  }

  static LoginResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return LoginResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "token": token,
      };

  @override
  String toString() => 'LoginResponseModel(token: $token)';
}
