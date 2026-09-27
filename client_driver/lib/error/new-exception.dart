class NewException implements Exception {
  final String errorMessage;
  final String? additionalData;

  NewException(this.errorMessage, this.additionalData);
}
