import 'package:expensego/core/errors/failures.dart';
import 'package:expensego/features/profile/domain/repositories/profile_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteAccount {
  final ProfileRepository repository;

  DeleteAccount(this.repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
  }) async {
    return await repository.deleteAccount(email: email, password: password);
  }
}
