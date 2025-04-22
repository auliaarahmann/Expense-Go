// // lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:expensego/core/errors/exceptions.dart';

abstract class AuthService {
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserCredential> signInWithGoogle();

  Future<void> reloadCurrentUser(); // Reloading current user data

  Future<void> signOut();
  Stream<User?> get authStateChanges;
  User? get currentUser;

  // Menambahkan fungsi reauthenticate
  Future<void> reauthenticate({
    required String email,
    required String password,
  });
}

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Authentication failed');
    }
  }

  @override
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Registration failed');
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw AuthException('Google Sign-In aborted');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google Sign-In failed');
    }
  }

  @override
  Future<void> reloadCurrentUser() async {
    await _firebaseAuth.currentUser?.reload();
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // Implementasi reauthenticate
  @override
  Future<void> reauthenticate({
    required String email,
    required String password,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const UnauthenticatedException('User not authenticated');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    try {
      await user.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Reauthentication failed');
    }
  }
}
