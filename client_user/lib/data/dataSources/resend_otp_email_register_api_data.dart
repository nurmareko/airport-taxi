import 'dart:convert';
import 'package:client_user/data/models/request/resend_otp_email_register_request_model.dart';
import 'package:client_user/data/models/response/resend_otp_email_register_response_model_model.dart';
import 'package:client_user/error/new-exception.dart';
import 'package:http/http.dart' as http;

class ResendOTPEmailRegisterAPIData {
  Future<ResendOTPEmailRegisterResponseModel> resendOTPEmailRegister(
    ResendOTPEmailRegisterRequestModel resendOTPEmailRegisterRequestModel,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('https://airporttaxisharingappserver-production.up.railway.app/api/customers/resendOTPEmailRegister'),
        headers: {'Content-Type': 'application/json'},
        body: resendOTPEmailRegisterRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using ResendOTPEmailRegisterResponseModel.fromResponseData
        final ResendOTPEmailRegisterResponseModel result =
            ResendOTPEmailRegisterResponseModel.fromResponseData(json.decode(response.body));

        print("Successfully Resend OTP Register, email: ${result.email}");

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
        throw Exception("Failed resend otp code");
      }
    }
  }
}
