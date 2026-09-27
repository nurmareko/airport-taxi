import 'dart:convert';
import 'package:airport_taxi_sharing_user_client/data/dataSources/api_constants.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/check_authentication_response_model.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:airport_taxi_sharing_user_client/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class CheckAuthenticationAPIData {
  Future<CheckAuthenticationResponseModel> checkAuthentication() async {
    try {
      String? token = await SecureStorage().getToken();

      final url = Uri.parse('${ApiConstants.baseUrl}customers/checkAuthentication');
      final response = await http.get(
        url,
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using CheckAuthenticationResponseModel.fromResponseData
        final CheckAuthenticationResponseModel result =
            CheckAuthenticationResponseModel.fromResponseData(
                json.decode(response.body));

        print(
            "Successfully Checking Authentication, status is Authenticated, token: ${result.token}");

        // Return the result
        return result;
      } else {
        final Map<String, dynamic> errorDetails = json.decode(response.body);
        print(errorDetails);
        String errorMessage = errorDetails['error']['message'];

        throw NewException(errorMessage, null);
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
        throw Exception("Failed checking authentication");
      }
    }
  }
}
