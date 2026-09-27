import 'dart:convert';

import 'package:airport_taxi_sharing_driver_client/data/dataSources/api_constant.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/request/update_driver_request_model.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/update_driver_response_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:airport_taxi_sharing_driver_client/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class UpdateDriverAPIData {
  Future<UpdateDriverResponseModel> updateDriver(
    UpdateDriverRequestModel updateDriverRequestModel,
  ) async {
    try {
      String? token = await SecureStorage().getToken();
      final url = Uri.parse('${ApiConstants.baseUrl}drivers/current');

      // Create a new multipart request
      var request = http.MultipartRequest('PATCH', url);

      // Add headers
      request.headers['Authorization'] = '$token';

      // Add fields (non-file data)
      request.fields['noMembership'] = updateDriverRequestModel.noMembership;
      request.fields['licensePlate'] = updateDriverRequestModel.licensePlate;
      request.fields['name'] = updateDriverRequestModel.name;
      request.fields['phoneNumber'] = updateDriverRequestModel.phoneNumber;

      // Add image file if provided
      if (updateDriverRequestModel.image != null) {
        request.files.add(http.MultipartFile(
          'image',
          updateDriverRequestModel.image!.readAsBytes().asStream(),
          updateDriverRequestModel.image!.lengthSync(),
          filename: updateDriverRequestModel.image!.path
              .split('/')
              .last, // Mendapatkan nama file dari path
        ));
      }

      // Send the request
      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        // Parse the JSON response using UpdateDriverResponseModel.fromResponseData
        final UpdateDriverResponseModel result =
            UpdateDriverResponseModel.fromResponseData(
                json.decode(response.body));

        print("Successfully Update Driver Data, email: ${result.email}");

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
        throw Exception("Failed update Driver");
      }
    }
  }
}
