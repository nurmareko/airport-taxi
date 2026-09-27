import 'dart:convert';
import 'package:airport_taxi_sharing_user_client/data/dataSources/api_constants.dart';
import 'package:airport_taxi_sharing_user_client/error/new-exception.dart';
import 'package:airport_taxi_sharing_user_client/utils/secure_storage.dart';
import 'package:http/http.dart' as http;

class LogoutAPIData {
  Future<void> logout() async {
    try {
      String? token = await SecureStorage().getToken();
      final url = Uri.parse('${ApiConstants.baseUrl}customers/logout');
      final response = await http.delete(
        url,
        headers: {'Authorization': '$token'},
      );

      if (response.statusCode == 200) {
        print("Successfully Logout");
        // Delete token
        await SecureStorage().deleteToken();
      } else {
        final Map<String, dynamic> errorDetails = json.decode(response.body);
        print(errorDetails);
        String errorMessage = errorDetails['error']['message'];

        throw NewException(errorMessage, null);
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception("Unable to connect to the server");
      } else if (e is NewException) {
        rethrow;
      } else {
        print("Non-exception error occurred: $e");
        throw Exception("Failed to logout");
      }
    }
  }
}
