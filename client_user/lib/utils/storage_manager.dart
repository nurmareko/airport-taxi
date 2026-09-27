// import 'package:shared_preferences/shared_preferences.dart';

// class StorageManager {
//   static const String _keyEmail = 'email';
//   static const String _keyName = 'name';
//   static const String _keyPhoneNumber = 'phoneNumber';

//   // Simpan data pelanggan
//   static Future<void> saveCustomerData({
//     required String email,
//     required String name,
//     required String phoneNumber,
//   }) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString(_keyEmail, email);
//     await prefs.setString(_keyName, name);
//     await prefs.setString(_keyPhoneNumber, phoneNumber);
//   }

//   // Mendapatkan data pelanggan
//   static Future<Map<String, String>> getCustomerData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     String email = prefs.getString(_keyEmail) ?? '';
//     String name = prefs.getString(_keyName) ?? '';
//     String phoneNumber = prefs.getString(_keyPhoneNumber) ?? '';

//     return {
//       'email': email,
//       'name': name,
//       'phoneNumber': phoneNumber,
//     };
//   }

//   // Menghapus data pelanggan
//   static Future<void> clearCustomerData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_keyEmail);
//     await prefs.remove(_keyName);
//     await prefs.remove(_keyPhoneNumber);
//   }
// }
