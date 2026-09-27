import 'dart:convert';
import 'dart:io';

class UpdateCustomerRequestModel {
  final String name;
  final String phoneNumber;
  final File? image;
  UpdateCustomerRequestModel({
    required this.name,
    required this.phoneNumber,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      // Ubah gambar menjadi base64 string jika tidak null
      'image': image != null ? base64Encode(image!.readAsBytesSync()) : null,
    };
  }

  factory UpdateCustomerRequestModel.fromMap(Map<String, dynamic> map) {
    return UpdateCustomerRequestModel(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      image: map['image'] != null
          ? File.fromRawPath(base64Decode(map['image']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateCustomerRequestModel.fromJson(String source) =>
      UpdateCustomerRequestModel.fromMap(json.decode(source));
}
