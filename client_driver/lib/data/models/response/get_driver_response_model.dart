class GetDriverResponseModel {
  String token;
  String noMembership;
  String licensePlate;
  String email;
  String name;
  String phoneNumber;
  String photo;
  double lat = 0;
  double long = 0;

  GetDriverResponseModel({
    required this.token,
    required this.noMembership,
    required this.licensePlate,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.photo,
    required this.lat,
    required this.long,
  });

  factory GetDriverResponseModel.fromJson(Map<String, dynamic> json) {
    return GetDriverResponseModel(
      token: json["token"],
      noMembership: json["noMembership"],
      licensePlate: json["licensePlate"],
      email: json["email"],
      name: json["name"],
      phoneNumber: json["phoneNumber"],
      photo: json["photo"],
      lat: json["lat"],
      long: json["long"],
    );
  }

  static GetDriverResponseModel fromResponseData(
    Map<String, dynamic> responseData,
  ) {
    return GetDriverResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "token": token,
        "noMembership": noMembership,
        "licensePlate": licensePlate,
        "email": email,
        "name": name,
        "phoneNumber": phoneNumber,
        "photo": photo,
        "lat": lat,
        "long": long,
      };

  @override
  String toString() =>
      'GetDriverResponseModel(token: $token, noMembership: $noMembership, licensePlate: $licensePlate, email: $email, name: $name, phoneNumber: $phoneNumber, photo: $photo)';
}
