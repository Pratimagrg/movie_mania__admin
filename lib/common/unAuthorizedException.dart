class UnAuthorizedException implements Exception {
  String errorMessage;

  UnAuthorizedException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}
