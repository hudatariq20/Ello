import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:voice_input/shared/theme/persona_type.dart';

class ElloIntroData extends Equatable{
  final PersonaType type;
  final String name;
  final String category;
  final String actionLabel;
  final IconData icon;
  final Color accentColor;

  const ElloIntroData({
    required this.type,
    required this.name,
    required this.category,
    required this.actionLabel,
    required this.icon,
    required this.accentColor,
  });
  
  @override
  List<Object?> get props => [type, name, category, actionLabel, icon, accentColor];
}