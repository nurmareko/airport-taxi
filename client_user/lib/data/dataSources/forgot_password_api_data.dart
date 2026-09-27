import 'dart:convert';
import 'package:client_user/data/models/request/forgot_password_request_model.dart';
import 'package:client_user/data/models/response/forgot_password_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordAPIData {
  Future<ForgotPasswordResponseModel> forgotPassword(
    ForgotPasswordRequestModel forgotPasswordRequestModel,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('https://airporttaxisharingappserver-production.up.railway.app/api/customers/forgotPassword'),
        headers: {'Content-Type': 'application/json'},
        body: forgotPasswordRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using ForgotPasswordResponseModel.fromResponseData
        final ForgotPasswordResponseModel result =
            ForgotPasswordResponseModel.fromResponseData(json.decode(response.body));

        print("Successfully checking email, email: ${result.email}. Redirect to email verification then reset password");

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
