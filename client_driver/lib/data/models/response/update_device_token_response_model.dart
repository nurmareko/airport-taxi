class UpdateDeviceTokenResponseModel {
  String deviceToken;

  UpdateDeviceTokenResponseModel({
    required this.deviceToken,
  });

  factory UpdateDeviceTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return UpdateDeviceTokenResponseModel(
      deviceToken: json["deviceToken"],
    );
  }

  static UpdateDeviceTokenResponseModel fromResponseData(
      Map<String, dynamic> responseData) {
    return UpdateDeviceTokenResponseModel.fromJson(responseData['data']);
  }

  Map<String, dynamic> toJson() => {
        "deviceToken": deviceToken,
      };

  @override
  String toString() => 'UpdateDeviceTokenResponseModel(deviceToken: $deviceToken)';
}
