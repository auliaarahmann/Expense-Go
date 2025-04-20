// lib/features/profile/domain/usecases/change_password.dart

import 'package:expensego/core/errors/failures.dart';
import 'package:expensego/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChangePassword {
  final ProfileRepository repository;

  ChangePassword(this.repository);

  Future<Either<Failure, void>> call({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}