class ApiClientException implements Exception {
  final String message;

  const ApiClientException(this.message);

  @override
  String toString() => "ServiceException: $message";
}
