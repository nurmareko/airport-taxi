import 'dart:convert';

class RejectOrderanRequestModel {
  final String orderId;

  RejectOrderanRequestModel({
    required this.orderId,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
    };
  }

  factory RejectOrderanRequestModel.fromMap(Map<String, dynamic> map) {
    return RejectOrderanRequestModel(
      orderId: map['orderId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RejectOrderanRequestModel.fromJson(String source) =>
      RejectOrderanRequestModel.fromMap(json.decode(source));
}
