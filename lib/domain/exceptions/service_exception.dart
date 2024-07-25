class ServiceException implements Exception {
  final String message;

  const ServiceException(this.message);

  @override
  String toString() => "ServiceException: $message";
}
