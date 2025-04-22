// lib/features/auth/domain/repositories/auth_repository.dart

import 'package:fpdart/fpdart.dart';
import 'package:expensego/core/errors/failures.dart';
import 'package:expensego/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();

  Stream<UserEntity?> get authStateChanges;
  UserEntity? get currentUser;

  Future<Either<Failure, UserEntity>> getCurrentUserData();
}
