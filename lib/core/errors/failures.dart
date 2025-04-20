// lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(super.message);
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure(super.message);
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure(super.message);
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure(super.message);
}

class NoUserFoundFailure extends Failure {
  const NoUserFoundFailure(super.message);
}

class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure(super.message);
}
