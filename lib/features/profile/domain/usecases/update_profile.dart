// lib/features/auth/domain/usecases/get_current_user.dart
import 'package:fpdart/fpdart.dart';
import 'package:expensego/core/errors/failures.dart';
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'package:expensego/features/profile/domain/repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<Either<Failure, void>> call(ProfileEntity profile, {String? newPassword}) {
    return repository.updateProfile(profile, newPassword: newPassword);
  }
}


