// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import 'package:expensego/core/errors/failures.dart';
// import 'package:expensego/core/errors/exceptions.dart';
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'package:expensego/features/profile/domain/repositories/profile_repository.dart';
import 'package:expensego/features/profile/data/datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, void>> updateProfile(
    ProfileEntity profile, {
    String? newPassword,
  }) async {
    try {
      await remoteDataSource.updateProfile(profile, newPassword: newPassword);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
