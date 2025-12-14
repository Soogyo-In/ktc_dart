class NoSuchElementException implements Exception {
  final String? message;

  NoSuchElementException([this.message]);

  @override
  String toString() => message == null
      ? "NoSuchElementException"
      : "NoSuchElementException: $message";
}
