import 'dart:convert';

class SendReportRequestModel {
  final String orderId;
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
      orderId: map['orderId'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SendReportRequestModel.fromJson(String source) =>
      SendReportRequestModel.fromMap(json.decode(source));
}
