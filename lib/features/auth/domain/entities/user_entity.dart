// lib/features/auth/domain/entities/user_entity.dart
import 'package:firebase_auth/firebase_auth.dart';

class UserEntity {
  final String uid;
  final String? email;
  final String? name;
  final String? photoUrl;
  final DateTime? createdAt;

  UserEntity({
    required this.uid,
    this.email,
    this.name,
    this.photoUrl,
    this.createdAt,
  });

  factory UserEntity.fromFirebaseUser(User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email,
      name: user.displayName,
      photoUrl: user.photoURL,
      createdAt: user.metadata.creationTime,
    );
  }
}
