// lib/features/auth/domain/respository/auth/base_auth_repository.dart

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:voice_input/features/auth/domain/entities/app_user.dart';

abstract class BaseAuthRepository {
  //Firebase Auth stream (user signed in/out changes)
  Stream<auth.User?> get user;

  //Returns the current Firebase user’s UID
  String? get currentUserId;

  //Sign up and return the Firebase user
  Future<auth.User?> signUp({
    required AppUser user,
    required String password,
  });

  //Log in using email and password
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  //reset password
  Future<void> resetPassword({required String email});

  //Sign out the current user
  Future<void> signOut();
}
