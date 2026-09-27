import 'dart:convert';

class CancelOrderanRequestModel {
  final String orderId;

  CancelOrderanRequestModel({
    required this.orderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
    };
  }

  factory CancelOrderanRequestModel.fromMap(Map<String, dynamic> map) {
    return CancelOrderanRequestModel(
      orderId: map['orderId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CancelOrderanRequestModel.fromJson(String source) =>
      CancelOrderanRequestModel.fromMap(json.decode(source));
}
