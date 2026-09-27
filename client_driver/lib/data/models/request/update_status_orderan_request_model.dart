import 'dart:convert';

class UpdateStatusOrderanRequestModel {
  final String orderId; // Changed to String
  final int status;

  UpdateStatusOrderanRequestModel({
    required this.orderId,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId, // Changed to String
      'status': status,
    };
  }

  factory UpdateStatusOrderanRequestModel.fromMap(Map<String, dynamic> map) {
    return UpdateStatusOrderanRequestModel(
      orderId: map['orderId'] ?? '', // Changed to String
      status: map['status']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateStatusOrderanRequestModel.fromJson(String source) =>
      UpdateStatusOrderanRequestModel.fromMap(json.decode(source));
}
