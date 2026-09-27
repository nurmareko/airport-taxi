class GetCustomerResponseModel {
  String token;
  String email;
  String name;
  String phoneNumber;
  String photo;
  double lat;
  double long;

  GetCustomerResponseModel({
    required this.token,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.photo,
    required this.lat,
    required this.long,
  });

  factory GetCustomerResponseModel.fromJson(Map<String, dynamic> json) {
    return GetCustomerResponseModel(
      token: json["token"],
      email: json["email"],
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      photo: json["photo"],
      lat: json["lat"],
      long: json["long"],
    );
  }

  static GetCustomerResponseModel fromResponseData(
    Map<String, dynamic> responseData,
  ) {
    return GetCustomerResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "token": token,
        "email": email,
        "name": name,
        "phoneNumber": phoneNumber,
        "photo": photo,
        "lat": lat,
        "long": long,
      };

  @override
  String toString() =>
      'GetCustomerResponseModel(token: $token, email: $email, name: $name, phoneNumber: $phoneNumber, photo: $photo, lat: $lat, long: $long)';
}
