import 'dart:convert';
import 'package:airport_taxi_sharing_user_client/data/dataSources/api_constants.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/get_current_order_response_model.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:airport_taxi_sharing_user_client/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class GetCurrentOrderAPIData {
  Future<GetCurrentOrderResponseModel> getCurrentOrder() async {
    try {
      String? token = await SecureStorage().getToken();
      final url =
          Uri.parse('${ApiConstants.baseUrl}customers/orders/getCurrentOrder');

      final response = await http.get(
        url,
        headers: {'Authorization': '$token'},
      );

      // Print response body
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse the JSON response using GetCurrentOrderResponseModel.fromJson
        final GetCurrentOrderResponseModel result =
            GetCurrentOrderResponseModel.fromJson(
                json.decode(response.body)['data']); // Parse 'data' key

        print("Successfully current order customer");

        // Return the result
        return result;
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
