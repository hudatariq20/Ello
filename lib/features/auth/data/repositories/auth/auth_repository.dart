import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:voice_input/features/auth/data/repositories/user/user_repository.dart';
import 'package:voice_input/features/auth/domain/entities/app_user.dart';
import 'package:voice_input/features/auth/domain/respository/auth/base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;
  final UserRepository _userRepository;

  AuthRepository({
    auth.FirebaseAuth? firebaseAuth,
    required UserRepository userRepository,
  })  : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _userRepository = userRepository;

  @override
  Stream<auth.User?> get user => _firebaseAuth.authStateChanges();

  @override
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  @override
  Future<auth.User?> signUp({
    required AppUser user,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: password);

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('User creation failed: No Firebase user returned');
      }

      final newUser = user.copyWith(id: firebaseUser.uid);
      await _userRepository.createUser(newUser);

      return firebaseUser;
    } catch (e, st) {
      debugPrint('signUp error: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (e, st) {
      debugPrint('FirebaseAuthException: ${e.message}\n$st');
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      debugPrint(' Password reset email sent to $email');
    } on auth.FirebaseAuthException catch (e, st) {
      debugPrint('resetPassword error: ${e.message}\n$st');
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
