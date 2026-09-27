import 'dart:convert';
import 'package:client_user/data/dataSources/api_constants.dart';
import 'package:client_user/data/models/response/get_history_order_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:client_user/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class GetHistoryOrderAPIData {
  Future<GetHistoryOrderResponseModel> getHistoryOrder() async {
    try {
      String? token = await SecureStorage().getToken();
      final url =
          Uri.parse('${ApiConstants.baseUrl}customers/orders/getHistoryOrder');
      final response = await http.get(
        url,
        headers: {'Authorization': '$token'},
      );
      print(token);

      if (response.statusCode == 200) {
        // Parse the JSON response using GetHistoryOrderResponseModel.fromJson
        final Map<String, dynamic> responseData = json.decode(response.body);
        final GetHistoryOrderResponseModel result =
            GetHistoryOrderResponseModel.fromJson(responseData);

        print("Successfully Get History Order Data : $result");

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
        throw Exception("Failed get history order data");
      }
    }
  }
}
