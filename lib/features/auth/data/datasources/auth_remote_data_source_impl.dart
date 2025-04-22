// lib/features/auth/data/datasources/auth_remote_data_source_impl.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:expensego/core/services/auth_service.dart';
import 'package:expensego/features/auth/data/datasources/auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthService _authService;

  AuthRemoteDataSourceImpl(this._authService);

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _authService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return await _authService.registerWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    return await _authService.signInWithGoogle();
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  @override
  User? get currentUser => _authService.currentUser;
}
