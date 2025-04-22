// lib/features/auth/domain/usecases/sign_in_with_google.dart

import 'package:fpdart/fpdart.dart';
import 'package:expensego/core/errors/failures.dart';
import 'package:expensego/features/auth/domain/entities/user_entity.dart';
import 'package:expensego/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.signInWithGoogle();
  }
}
