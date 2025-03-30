class ApiException implements Exception {
  final String message;
  final int statusCode;
  final dynamic responseData;

  ApiException(this.message, this.statusCode, this.responseData);

  @override
  String toString() => 'ApiException: $message (Status code: $statusCode)';
}
