import 'dart:convert';
import 'package:client_driver/data/dataSources/api_constant.dart';
import 'package:client_driver/data/models/request/update_device_token_request_model.dart';
import 'package:client_driver/data/models/response/update_device_token_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:client_driver/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class UpdateDeviceTokenAPIData {
  Future<UpdateDeviceTokenResponseModel> updateDeviceToken(
    UpdateDeviceTokenRequestModel updateDeviceTokenRequestModel,
  ) async {
    try {
      String? token = await SecureStorage().getToken();
      final url =
          Uri.parse('${ApiConstants.baseUrl}drivers/updateDeviceToken');

      final response = await http.patch(
        url,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json'
        },
        body: updateDeviceTokenRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using UpdateDeviceTokenResponseModel.fromResponseData
        final UpdateDeviceTokenResponseModel result =
            UpdateDeviceTokenResponseModel.fromResponseData(
                json.decode(response.body));

        print(
            "Successfully update device token, deviceToken: ${result.deviceToken}");

        // Return the result
        return result;
      } else {
        final Map<String, dynamic> errorDetails = json.decode(response.body);
        print(errorDetails);
        String errorMessage = errorDetails['error']['message'];
        String deviceToken = errorDetails['error']['additionalData'];

        throw NewException(errorMessage, deviceToken);
      }
    } catch (e) {
      // Check if the error is a network-related issue
      if (e is http.ClientException) {
        throw Exception("Unable to connect to the server");
      } else if (e is NewException) {
        // Handle other exceptions
        rethrow; // Rethrow the exception
      } else {
        // Print the error for debugging
        print("Non-exception error occurred: $e");
        throw Exception("Failed to update device token");
      }
    }
  }
}
