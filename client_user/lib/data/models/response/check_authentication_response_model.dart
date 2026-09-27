class CheckAuthenticationResponseModel {
  String token;

  CheckAuthenticationResponseModel({
    required this.token,
  });

  factory CheckAuthenticationResponseModel.fromJson(Map<String, dynamic> json) {
    return CheckAuthenticationResponseModel(
      token: json["token"],
    );
  }

  static CheckAuthenticationResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return CheckAuthenticationResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "token": token,
      };

  @override
  String toString() => 'CheckAuthenticationResponseModel(token: $token)';
}
