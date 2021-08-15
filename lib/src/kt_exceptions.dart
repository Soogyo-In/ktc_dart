part of ktc_dart;

class NoSuchElementException implements Exception {
  final String? message;

  NoSuchElementException([this.message]);

  @override
  String toString() => message == null
      ? "NoSuchElementException"
      : "NoSuchElementException: $message";
}
