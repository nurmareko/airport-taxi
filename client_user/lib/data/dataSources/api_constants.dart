import 'package:flutter/foundation.dart';

class ApiConstants {
  static const String _configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    final url = _configuredBaseUrl.isNotEmpty
        ? _configuredBaseUrl
        : !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? 'http://10.0.2.2:3001/api/'
            : 'http://localhost:3001/api/';
    return url.endsWith('/') ? url : '$url/';
  }
}
