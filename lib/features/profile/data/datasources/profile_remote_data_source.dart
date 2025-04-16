// lib/features/auth/data/datasources/auth_remote_data_source.dart
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<void> updateProfile(ProfileEntity profile, {String? newPassword});
}
