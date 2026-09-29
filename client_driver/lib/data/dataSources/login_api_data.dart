import 'dart:convert';

import 'package:client_driver/data/dataSources/api_constant.dart';
import 'package:client_driver/data/models/request/login_request_model.dart';
import 'package:client_driver/data/models/response/login_response_model.dart';
import 'package:client_driver/error/new-exception.dart';
import 'package:client_driver/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginAPIData {
  final SecureStorage secureStorage;
  LoginAPIData(this.secureStorage);
  Future<LoginResponseModel> login(
    LoginRequestModel loginRequestModel,
  ) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}drivers/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: loginRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using LoginResponseModel.fromResponseData
        final LoginResponseModel result =
            LoginResponseModel.fromResponseData(json.decode(response.body));

        print("Successfully Login, token: ${result.token}");

        // Save the token securely
        await secureStorage.updateToken(result.token);

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
        throw Exception("Failed login");
      }
    }
  }
}
