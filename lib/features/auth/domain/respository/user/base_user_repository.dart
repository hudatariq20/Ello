// lib/features/auth/domain/respository/user/base_user_repository.dart

import 'package:voice_input/features/auth/domain/entities/app_user.dart';

//base user repository for app user
abstract class BaseUserRepository {
  // Stream the Firestore user document
  Stream<AppUser> getUser(String userId);

  // Create the Firestore user document
  Future<void> createUser(AppUser user);

  // Update the Firestore user document
  Future<void> updateUser(AppUser user);
}
