import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voice_input/shared/theme/persona_type.dart';

class ElloIntroData extends Equatable {
  final PersonaType type;
  final String category;
  final String actionLabel;
  final IconData icon;

  const ElloIntroData({
    required this.type,
    required this.category,
    required this.actionLabel,
    required this.icon,
  });

  @override
  List<Object?> get props => [
        type,
        category,
        actionLabel,
        icon,
      ];
}