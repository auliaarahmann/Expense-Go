// lib/features/auth/data/repositories/auth_repository_impl.dart

import 'package:expensego/core/errors/exceptions.dart';
import 'package:expensego/core/errors/failures.dart';
import 'package:expensego/core/network/network_info.dart';
import 'package:expensego/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'package:expensego/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> updateProfile(ProfileEntity profile) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateProfile(profile);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure('Failed to update profile'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure('Failed to change password'));
      } on WrongPasswordException {
        return Left(WrongPasswordFailure('Incorrect current password'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount({required String email,
    required String password,}) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteAccount(email: email, password: password);
        return const Right(null);
      } on ServerException {
        return Left(ServerFailure('Failed to delete account your'));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  
}
