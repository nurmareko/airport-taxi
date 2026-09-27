import 'dart:convert';
import 'package:client_user/data/dataSources/api_constants.dart';
import 'package:client_user/data/models/response/get_taxis_within_radius_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:client_user/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class GetTaxisWithinRadiusAPIData {
  Future<GetTaxisWithinRadiusResponseModel> getTaxisWithinRadius() async {
    try {
      String? token = await SecureStorage().getToken();
      final url = Uri.parse(
          '${ApiConstants.baseUrl}customers/orders/getTaxisWithinRadius');

      final response = await http.get(
        url,
        headers: {'Authorization': '$token'},
      );

      // Print response body
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Check if response body is not empty
        if (response.body.isNotEmpty) {
          // Parse the JSON response using GetTaxisWithinRadiusResponseModel.fromJson
          final GetTaxisWithinRadiusResponseModel result =
              GetTaxisWithinRadiusResponseModel.fromJson(
                  json.decode(response.body)['data']); // Parse 'data' key

          print(
              "Successfully get data taxis within radius");

          // Return the result
          return result;
        } else {
          throw Exception("Empty response body");
        }
      } else {
        final Map<String, dynamic> errorDetails = json.decode(response.body);
        print(errorDetails);
        String errorMessage = errorDetails['error']['message'];
        print('haloo ini error messagenya : $errorMessage');

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
        throw Exception(e);
      }
    }
  }
}
