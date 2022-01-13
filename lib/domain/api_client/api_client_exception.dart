class ApiClientExceptionType {
  static const String notModified = 'Error: 304 Not Modified';
  static const String unprocessableEntity = 'Error: 422 Unprocessable Entity';
  static const String serviceUnavailable = 'Error: 503 Service Unavailable';
  static const String noInternetConnection = 'No Internet Connection';
  static const String unknownError = 'Unknown Error';
  static const String unauthorisedRequest =
      'API rate limit exceeded. Please sign in';
}

class ApiClientException implements Exception {
  final String type;

  ApiClientException(this.type);
}
