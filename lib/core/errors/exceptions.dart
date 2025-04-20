// lib/core/errors/exceptions.dart
class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => 'AuthException: $message';
}

class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}

class WrongPasswordException implements Exception {
  final String message;

  WrongPasswordException(this.message);

  @override
  String toString() => 'WrongPasswordException: $message';
}

class UnauthenticatedException implements Exception {
  final String message;

  const UnauthenticatedException(this.message);

  @override
  String toString() => 'UnauthenticatedException: $message';
}
