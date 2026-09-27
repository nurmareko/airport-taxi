import 'dart:convert';

class AcceptOrderanRequestModel {
  final String orderId;

  AcceptOrderanRequestModel({
    required this.orderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
    };
  }

  factory AcceptOrderanRequestModel.fromMap(Map<String, dynamic> map) {
    return AcceptOrderanRequestModel(
      orderId: map['orderId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory AcceptOrderanRequestModel.fromJson(String source) =>
      AcceptOrderanRequestModel.fromMap(json.decode(source));
}
