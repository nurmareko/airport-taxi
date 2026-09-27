import 'dart:convert';

import 'package:airport_taxi_sharing_user_client/data/dataSources/api_constants.dart';
import 'package:airport_taxi_sharing_user_client/data/models/request/update_customer_request_model.dart';
import 'package:airport_taxi_sharing_user_client/data/models/response/update_customer_response_model.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:airport_taxi_sharing_user_client/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class UpdateCustomerAPIData {
  Future<UpdateCustomerResponseModel> updateCustomer(
    UpdateCustomerRequestModel updateCustomerRequestModel,
  ) async {
    try {
      String? token = await SecureStorage().getToken();
      final url = Uri.parse('${ApiConstants.baseUrl}customers/current');

      // Create a new multipart request
      var request = http.MultipartRequest('PATCH', url);

      // Add headers
      request.headers['Authorization'] = '$token';

      // Add fields (non-file data)
      request.fields['name'] = updateCustomerRequestModel.name;
      request.fields['phoneNumber'] = updateCustomerRequestModel.phoneNumber;

      // Add image file if provided
      if (updateCustomerRequestModel.image != null) {
        request.files.add(http.MultipartFile(
          'image',
          updateCustomerRequestModel.image!.readAsBytes().asStream(),
          updateCustomerRequestModel.image!.lengthSync(),
          filename: updateCustomerRequestModel.image!.path
              .split('/')
              .last, // Mendapatkan nama file dari path
        ));
      }

      // Send the request
      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        // Parse the JSON response using UpdateCustomerResponseModel.fromResponseData
        final UpdateCustomerResponseModel result =
            UpdateCustomerResponseModel.fromResponseData(
                json.decode(response.body));

        print("Successfully Update Customer Data, email: ${result.email}");

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
        throw Exception("Failed update customer");
      }
    }
  }
}
