// lib/features/auth/domain/repositories/auth_repository.dart
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'package:fpdart/fpdart.dart';
import 'package:expensego/core/errors/failures.dart';

abstract class ProfileRepository {
  Future<Either<Failure, void>> updateProfile(
    ProfileEntity profile, {
    String? newPassword,
  });
}
