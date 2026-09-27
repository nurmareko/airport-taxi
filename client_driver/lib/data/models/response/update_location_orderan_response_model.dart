class UpdateLocationOrderanResponseModel {
  int id;
  double lat;
  double long;

  UpdateLocationOrderanResponseModel({
    required this.id,
    required this.lat,
    required this.long,
  });

  factory UpdateLocationOrderanResponseModel.fromJson(
      Map<String, dynamic> json) {
    return UpdateLocationOrderanResponseModel(
      id: json["id"],
      lat: json["lat"],
      long: json["long"],
    );
  }

  static UpdateLocationOrderanResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return UpdateLocationOrderanResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "lat": lat,
        "long": long,
      };

  @override
  String toString() =>
      'UpdateLocationOrderanResponseModel(id: $id, lat: $lat, long: $long)';
}
