import 'dart:convert';

class SendReportRequestModel {
  final String orderId; // Changed from int to String
  final String message;

  SendReportRequestModel({
    required this.orderId,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'message': message,
    };
  }

  factory SendReportRequestModel.fromMap(Map<String, dynamic> map) {
    return SendReportRequestModel(
      orderId: map['orderId'] ?? '', // Updated to handle String type
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SendReportRequestModel.fromJson(String source) => SendReportRequestModel.fromMap(json.decode(source));
}
