import 'dart:convert';

class SendReviewRequestModel {
  final String orderId;
  final String review;
  final double rating;

  SendReviewRequestModel({
    required this.orderId,
    required this.review,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'review': review,
      'rating': rating,
    };
  }

  factory SendReviewRequestModel.fromMap(Map<String, dynamic> map) {
    return SendReviewRequestModel(
      orderId: map['orderId'] ?? '',
      review: map['review'] ?? '',
      rating: map['rating']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SendReviewRequestModel.fromJson(String source) =>
      SendReviewRequestModel.fromMap(json.decode(source));
}
