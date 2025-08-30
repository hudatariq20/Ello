// data/auth/user_dto.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:voice_input/features/auth/domain/entities/app_user.dart';

//data transfer object for app user interacts with cloud firestore
class UserDto extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String selectedPersona;
  final bool onboardingCompleted;
//constructor
  const UserDto({
    this.id,
    this.name = '',
    this.email = '',
    this.selectedPersona = '',
    this.onboardingCompleted = false,
  });

//read objects from cloud firestore
  factory UserDto.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return UserDto(
      id: snap.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      selectedPersona: data['selectedPersona'] ?? '',
      onboardingCompleted: data['onboardingCompleted'] ?? false,
    );
  }

//write objects to cloud firestore
  Map<String, Object> toDocument() {
    return {
      'name': name,
      'email': email,
      'selectedPersona': selectedPersona,
      'onboardingCompleted': onboardingCompleted,
    };
  }

//convert to domain object
  AppUser toDomain() {
    return AppUser(
      id: id,
      name: name,
      email: email,
      selectedPersona: selectedPersona,
      onboardingCompleted: onboardingCompleted,
    );
  }

//convert from domain object to dto object
  factory UserDto.fromDomain(AppUser user) {
    return UserDto(
      id: user.id,
      name: user.name,
      email: user.email,
      selectedPersona: user.selectedPersona,
      onboardingCompleted: user.onboardingCompleted,
    );
  }

//equatable
  @override
  List<Object?> get props =>
      [id, name, email, selectedPersona, onboardingCompleted];
}
