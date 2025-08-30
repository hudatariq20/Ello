// domain/entities/app_user.dart

import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String selectedPersona;
  final bool onboardingCompleted;

  const AppUser({
    this.id,
    this.name = '',
    this.email = '',
    this.password = '',
    this.selectedPersona = '',
    this.onboardingCompleted = false,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? selectedPersona,
    bool? onboardingCompleted,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      selectedPersona: selectedPersona ?? this.selectedPersona,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, email, password, selectedPersona, onboardingCompleted];
}
