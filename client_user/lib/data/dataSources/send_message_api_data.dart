import 'dart:convert';
import 'package:client_user/data/dataSources/api_constants.dart';
import 'package:client_user/data/models/request/send_message_request_model.dart';
import 'package:client_user/data/models/response/send_message_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:client_user/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class SendMessageAPIData {
  Future<SendMessageResponseModel> sendMessage(
    SendMessageRequestModel sendMessageRequestModel,
  ) async {
    try {
      String? token = await SecureStorage().getToken();
      final url = Uri.parse('${ApiConstants.baseUrl}customers/orders/sendMessage');

      final response = await http.post(
        url,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json'
        },
        body: sendMessageRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using SendMessageResponseModel.fromResponseData
        final SendMessageResponseModel result =
            SendMessageResponseModel.fromResponseData(json.decode(response.body));

        print("Successfull Send Message, Customer Id: ${result.id}");

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
        throw Exception("Failed send message");
      }
    }
  }
}
