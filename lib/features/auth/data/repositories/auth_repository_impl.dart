// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'dart:math';

import 'package:fpdart/fpdart.dart';
import 'package:expensego/core/errors/failures.dart';
import 'package:expensego/core/errors/exceptions.dart';
import 'package:expensego/features/auth/domain/entities/user_entity.dart';
import 'package:expensego/features/auth/domain/repositories/auth_repository.dart';
import 'package:expensego/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(UserEntity.fromFirebaseUser(userCredential.user!));
    } on AuthException catch (e) {
      return Left(InvalidCredentialsFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await remoteDataSource
          .registerWithEmailAndPassword(email: email, password: password);
      return Right(UserEntity.fromFirebaseUser(userCredential.user!));
    } on AuthException catch (e) {
      if (e.message.toLowerCase().contains('email already in use')) {
        return Left(EmailAlreadyInUseFailure(e.message));
      } else if (e.message.toLowerCase().contains('weak password')) {
        return Left(WeakPasswordFailure(e.message));
      }
      return Left(ServerFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getCurrentUserData() async {
    try {
      final userCredential = remoteDataSource.currentUser;
      if (userCredential != null) {
        return Right(UserEntity.fromFirebaseUser(userCredential));
      }
      return Left(NoUserFoundFailure(e.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((user) {
      return user != null ? UserEntity.fromFirebaseUser(user) : null;
    });
  }

  @override
  UserEntity? get currentUser {
    final user = remoteDataSource.currentUser;
    return user != null ? UserEntity.fromFirebaseUser(user) : null;
  }
}
