import 'dart:convert';
import 'package:client_user/data/dataSources/api_constants.dart';
import 'package:client_user/data/models/request/cancel_order_request_model.dart';
import 'package:client_user/data/models/response/cancel_order_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:client_user/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class CancelOrderAPIData {
  Future<CancelOrderResponseModel> cancelOrder(
    CancelOrderRequestModel cancelOrderRequestModel,
  ) async {
    try {
      String? token = await SecureStorage().getToken();
      final url =
          Uri.parse('${ApiConstants.baseUrl}customers/orders/cancelOrder');

      final response = await http.patch(
        url,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json'
        },
        body: cancelOrderRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using CancelOrderResponseModel.fromResponseData
        final CancelOrderResponseModel result =
            CancelOrderResponseModel.fromResponseData(
                json.decode(response.body));

        print("Successfully cancel order, order id: ${result.id}");

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
        throw Exception("Failed to cancel order");
      }
    }
  }
}
