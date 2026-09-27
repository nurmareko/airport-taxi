import 'dart:convert';
import 'package:airport_taxi_sharing_driver_client/data/dataSources/api_constant.dart';
import 'package:airport_taxi_sharing_driver_client/data/models/response/get_history_orderan_reponse_model.dart';
import 'package:airport_taxi_sharing_driver_client/error/new-exception.dart';
import 'package:airport_taxi_sharing_driver_client/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class GetHistoryOrderanAPIData {
  Future<GetHistoryOrderanResponseModel> getHistoryOrderanData() async {
    try {
      String? token = await SecureStorage().getToken();
      final url =
          Uri.parse('${ApiConstants.baseUrl}drivers/orders/getHistoryOrderan');
      final response = await http.get(
        url,
        headers: {'Authorization': '$token'},
      );
      print(token);

      if (response.statusCode == 200) {
        // Parse the JSON response using GetHistoryOrderanResponseModel.fromJson
        final Map<String, dynamic> responseData = json.decode(response.body);
        final GetHistoryOrderanResponseModel result =
            GetHistoryOrderanResponseModel.fromJson(responseData);

        print("Successfully Get History Orderan Data : $result");

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
        throw Exception("Failed get history orderan data");
      }
    }
  }
}
