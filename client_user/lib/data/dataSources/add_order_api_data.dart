import 'dart:convert';
import 'package:client_user/data/models/request/add_order_request_model.dart';
import 'package:client_user/data/models/response/add_order_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:client_user/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class AddOrderAPIData {
  
  Future<AddOrderResponseModel> addOrder(
    AddOrderRequestModel addOrderRequestModel,
  ) async {
    try {
      String? token = await SecureStorage().getToken();
      final response = await http.post(
        Uri.parse('https://airporttaxisharingappserver-production.up.railway.app/api/customers/orders/addOrder'),
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json'
        },
        body: addOrderRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using AddOrderResponseModel.fromResponseData
        final AddOrderResponseModel result =
            AddOrderResponseModel.fromResponseData(json.decode(response.body));

        print("Successfully add order data, email: ${result.id}");

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
