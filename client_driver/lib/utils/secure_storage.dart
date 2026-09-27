import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Fungsi untuk save token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }

  // Fungsi untuk update token
  Future<void> updateToken(String newToken) async {
    await _secureStorage.delete(key: 'token');
    await saveToken(newToken);
  }

  // Fungsi untuk mendapatkan token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }

  // Fungsi untuk menghapus token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'token');
  }

  // Fungsi untuk menyimpan device token
  Future<void> saveDeviceToken(String deviceToken) async {
    await _secureStorage.write(key: 'deviceToken', value: deviceToken);
  }

  // Fungsi untuk mendapatkan device token
  Future<String?> getDeviceToken() async {
    return await _secureStorage.read(key: 'deviceToken');
  }

  // Fungsi untuk menghapus device token
  Future<void> deleteDeviceToken() async {
    await _secureStorage.delete(key: 'deviceToken');
  }

  // Fungsi untuk update device token
  Future<void> updateDeviceToken(String newDeviceToken) async {
    await _secureStorage.delete(key: 'deviceToken');
    await saveDeviceToken(newDeviceToken);
  }
}
