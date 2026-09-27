import 'dart:convert';

class CancelOrderRequestModel {
  final String orderId; // Changed from int to String

  CancelOrderRequestModel({
    required this.orderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
    };
  }

  factory CancelOrderRequestModel.fromMap(Map<String, dynamic> map) {
    return CancelOrderRequestModel(
      orderId: map['orderId'] ?? '', // Updated to handle String type
    );
  }

  String toJson() => json.encode(toMap());

  factory CancelOrderRequestModel.fromJson(String source) =>
      CancelOrderRequestModel.fromMap(json.decode(source));
}
