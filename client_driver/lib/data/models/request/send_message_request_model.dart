import 'dart:convert';

class SendMessageRequestModel {
  final String orderId;
  final String message;

  SendMessageRequestModel({
    required this.orderId,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'message': message,
    };
  }

  factory SendMessageRequestModel.fromMap(Map<String, dynamic> map) {
    return SendMessageRequestModel(
      orderId: map['orderId'] ?? '',
      message: map['message'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SendMessageRequestModel.fromJson(String source) =>
      SendMessageRequestModel.fromMap(json.decode(source));
}
