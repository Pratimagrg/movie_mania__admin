class ErrorException implements Exception {
  String errorMessage;

  ErrorException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}
