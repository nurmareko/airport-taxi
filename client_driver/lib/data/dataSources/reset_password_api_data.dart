import 'dart:convert';

import 'package:airport_taxi_sharing_driver_client/data/models/request/reset_password_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/reset_password_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';

import 'package:http/http.dart' as http;

class ResetPasswordAPIData {
  Future<ResetPasswordResponseModel> resetPassword(
    ResetPasswordRequestModel resetPasswordRequestModel,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('https://airporttaxisharingappserver-production.up.railway.app/api/drivers/resetPassword'),
        headers: {'Content-Type': 'application/json'},
        body: resetPasswordRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using ResetPasswordResponseModel.fromResponseData
        final ResetPasswordResponseModel result =
            ResetPasswordResponseModel.fromResponseData(
                json.decode(response.body));

        print("Successfully reset password, email: ${result.email}");

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
