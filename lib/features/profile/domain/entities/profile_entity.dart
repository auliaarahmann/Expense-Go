// lib/features/profile/domain/entities/profile_entity.dart

class ProfileEntity {
  final String uid;
  final String? name;
  final String? photoUrl;
  final String? email;

  const ProfileEntity({
    required this.uid,
    this.name,
    this.photoUrl,
    this.email,
  });

  ProfileEntity copyWith({
    String? uid,
    String? name,
    String? photoUrl,
    String? email,
  }) {
    return ProfileEntity(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
    );
  }
}
