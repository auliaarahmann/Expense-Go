// lib/features/auth/data/datasources/auth_remote_data_source_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl(this.firebaseAuth, this.firestore);

  @override
  Future<void> updateProfile(
    ProfileEntity profile, {
    String? currentPassword,
    String? newPassword,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null || user.uid != profile.uid) {
      throw Exception('User not authenticated');
    }

    // Update Firebase Auth password (optional)
    // if (newPassword != null && newPassword.isNotEmpty) {
    //   await user.updatePassword(newPassword);
    // }
    if (newPassword != null && currentPassword != null) {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      // Reauthenticate
      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      } catch (e) {
        throw Exception('Password lama salah. Gagal update password.');
      }
    }

    // Update displayName
    await user.updateDisplayName(profile.name);

    // Simpan ke Firestore
    await firestore.collection('users').doc(profile.uid).set({
      'name': profile.name,
    }, SetOptions(merge: true));
  }
}
