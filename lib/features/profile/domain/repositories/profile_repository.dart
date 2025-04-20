// lib/features/profile/domain/repositories/profile_repository.dart

import 'package:expensego/core/errors/failures.dart';
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProfileRepository {
  Future<Either<Failure, void>> updateProfile(ProfileEntity profile);
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
  Future<Either<Failure, void>> deleteAccount({
    required String email,
    required String password,
  });
}
