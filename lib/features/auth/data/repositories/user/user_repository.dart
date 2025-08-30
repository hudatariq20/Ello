import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voice_input/features/auth/domain/entities/app_user.dart';
import 'package:voice_input/features/auth/domain/respository/user/base_user_repository.dart';
import 'package:voice_input/features/auth/data/models/app_user_dto.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createUser(AppUser user) async {
    try {
      final userDto =
          UserDto.fromDomain(user); //convert domain object to dto object
      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .set(userDto.toDocument()); //write to cloud firestore
    } catch (e, st) {
      debugPrint('createUser error: $e\n$st');
      rethrow;
    }
  }

  @override
  Stream<AppUser> getUser(String userId) {
    return _firebaseFirestore.collection('users').doc(userId).snapshots().map(
        (snap) => UserDto.fromSnapshot(snap)
            .toDomain()); //convert dto object to app user object
  }

  @override
  Future<void> updateUser(AppUser user) async {
    try {
      final userDto =
          UserDto.fromDomain(user); //convert app user object to dto object
      await _firebaseFirestore
          .collection('users')
          .doc(user.id)
          .update(userDto.toDocument()); //update cloud firestore
      debugPrint('✅ User document updated: ${user.id}');
    } catch (e, st) {
      debugPrint('updateUser error: $e\n$st');
      rethrow;
    }
  }
}
