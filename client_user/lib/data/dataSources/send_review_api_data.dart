import 'dart:convert';
import 'package:client_user/data/dataSources/api_constants.dart';
import 'package:client_user/data/models/request/send_review_request_model.dart';
import 'package:client_user/data/models/response/send_review_response_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:client_user/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class SendReviewAPIData {
  Future<SendReviewResponseModel> sendReview(
    SendReviewRequestModel sendReviewRequestModel,
  ) async {
    try {
      String? token = await SecureStorage().getToken();
      final url =
          Uri.parse('${ApiConstants.baseUrl}customers/orders/sendReview');

      final response = await http.patch(
        url,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json'
        },
        body: sendReviewRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using SendReviewResponseModel.fromResponseData
        final SendReviewResponseModel result =
            SendReviewResponseModel.fromResponseData(
                json.decode(response.body));

        print("Successfull Send Review, Customer Id: ${result.id}");

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
        throw Exception("Failed send review");
      }
    }
  }
}
