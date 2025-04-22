// lib/features/auth/data/datasources/auth_remote_data_source.dart
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> signInWithGoogle();

  Future<void> signOut();
  Stream<User?> get authStateChanges;
  User? get currentUser;
}
