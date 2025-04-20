// lib/features/auth/data/datasources/auth_remote_data_source_impl.dart
import 'package:expensego/core/errors/exceptions.dart';
import 'package:expensego/core/services/auth_service.dart';
import 'package:expensego/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:expensego/features/profile/domain/entities/profile_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final AuthService _authService;
  final FirebaseFirestore _firestore;

  ProfileRemoteDataSourceImpl(this._authService, this._firestore);

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw const UnauthenticatedException('User not authenticated');
      }

      // Update displayName
      await user.updateDisplayName(profile.name);

      await _firestore.collection('users').doc(user.uid).set({
        'name': profile.name,
        'photoUrl': profile.photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
        'email': user.email, // Keep email in sync with auth
      }, SetOptions(merge: true));

      // Reload user data after update
      await _authService.reloadCurrentUser();
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to update profile');
    } catch (e) {
      throw ServerException('Unexpected error occurred');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw const UnauthenticatedException('User not authenticated');
      }
      if (user.email == null) {
        throw ServerException('User email not available');
      }

      // Reauthenticate using AuthService
      await _authService.reauthenticate(
        email: user.email!,
        password: currentPassword,
      );

      // Update password via Firebase Auth
      await user.updatePassword(newPassword);

      // Update password changed timestamp in Firestore
      await _firestore.collection('users').doc(user.uid).update({
        'passwordChangedAt': FieldValue.serverTimestamp(),
      });

      // Reload user data after password change
      await _authService.reloadCurrentUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw WrongPasswordException('Current password is incorrect');
      }
      throw ServerException(e.message ?? 'Failed to change password');
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to change password');
    } catch (e) {
      throw ServerException('Unexpected error occurred');
    }
  }

  Future<ProfileEntity?> getProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return ProfileEntity(
          uid: uid,
          name: doc['name'],
          photoUrl: doc['photoUrl'],
          email: doc['email'],
        );
      }
      return null;
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to fetch profile');
    }
  }

  @override
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw const UnauthenticatedException('User not authenticated');
      }

      // Reauthenticate using AuthService
      await _authService.reauthenticate(email: user.email!, password: password);

      // Delete user data from Firestore first
      await _firestore.collection('users').doc(user.uid).delete();

      // Now delete the user from Firebase Auth
      await user.delete(); // This deletes the user in Firebase Authentication
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw ServerException(
          'Please login again before deleting your account.',
        );
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException('Incorrect password.');
      } else {
        throw ServerException(e.message ?? 'Failed to delete account');
      }
    } on FirebaseException catch (e) {
      throw ServerException(e.message ?? 'Failed to delete account');
    } catch (e) {
      throw ServerException('Unexpected error occurred');
    }
  }
}
