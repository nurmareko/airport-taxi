import 'dart:convert';
import 'dart:io';

class UpdateDriverRequestModel {
  final String noMembership;
  final String licensePlate;
  final String name;
  final String phoneNumber;
  final File? image;
  UpdateDriverRequestModel({
    required this.noMembership,
    required this.licensePlate,
    required this.name,
    required this.phoneNumber,
    this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'noMembership': noMembership,
      'licensePlate': licensePlate,
      'name': name,
      'phoneNumber': phoneNumber,
      // Ubah gambar menjadi base64 string jika tidak null
      'image': image != null ? base64Encode(image!.readAsBytesSync()) : null,
    };
  }

  factory UpdateDriverRequestModel.fromMap(Map<String, dynamic> map) {
    return UpdateDriverRequestModel(
      noMembership: map['noMembership'] ?? '',
      licensePlate: map['licensePlate'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      image: map['image'] != null
          ? File.fromRawPath(base64Decode(map['image']))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UpdateDriverRequestModel.fromJson(String source) =>
      UpdateDriverRequestModel.fromMap(json.decode(source));
}
