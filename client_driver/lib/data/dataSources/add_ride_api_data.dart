import 'dart:convert';

import 'package:client_driver/data/dataSources/api_constant.dart';
import 'package:client_driver/data/models/request/add_ride_request_model.dart';
import 'package:client_driver/data/models/response/add_ride_response_model.dart';

import 'package:client_driver/error/new-exception.dart';
import 'package:client_driver/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class AddRideAPIData {
  Future<AddRideResponseModel> addRide(
    AddRideRequestModel addRideRequestModel,
  ) async {
    try {
      String? token = await SecureStorage().getToken();
      final url = Uri.parse('${ApiConstants.baseUrl}drivers/rides/addRide');

      final response = await http.post(
        url,
        headers: {
          'Authorization': '$token',
          'Content-Type': 'application/json'
        },
        body: addRideRequestModel.toJson(),
      );

      if (response.statusCode == 200) {
        // Parse the JSON response using AddRideResponseModel.fromResponseData
        final AddRideResponseModel result =
            AddRideResponseModel.fromResponseData(json.decode(response.body));

        print("Successfull Add Ride Data, Driver Id: ${result.driverId}");

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
        throw Exception("Failed add ride");
      }
    }
  }
}
