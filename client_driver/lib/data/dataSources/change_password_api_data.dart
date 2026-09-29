import 'dart:convert';

import 'package:client_driver/data/dataSources/api_constant.dart';
import 'package:client_driver/data/models/request/change_password_request_model.dart';
import 'package:client_driver/data/models/response/change_password_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:client_driver/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class ChangePasswordAPIData {
  Future<ChangePasswordResponseModel> changePassword(
    ChangePasswordRequestModel changePasswordRequestModel,
  ) async {
    try {
      String? token = await SecureStorage().getToken();
      final url = Uri.parse('${ApiConstants.baseUrl}driver/changePassword');
      final response = await http.patch(url,
          headers: {
            'Authorization': '$token',
            'Content-Type': 'application/json'
          },
          body: changePasswordRequestModel.toJson());

      if (response.statusCode == 200) {
        // Parse the JSON response using ChangePasswordResponseModel.fromResponseData
        final ChangePasswordResponseModel result =
            ChangePasswordResponseModel.fromResponseData(
                json.decode(response.body));

        print("Successfully change password, email: ${result.email}");

        // Return the result
        return result;
      } else {
        final Map<String, dynamic> errorDetails = json.decode(response.body);
        print(errorDetails);
        String errorMessage = errorDetails['error']['message'];
        String email = errorDetails['error']['additionalData'];

        throw NewException(errorMessage, email);
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
        throw Exception("Failed process");
      }
    }
  }
}
