import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PersonaIntroData extends Equatable{
  final String name;
  final String category;
  final String actionLabel;
  final IconData icon;
  final Color accentColor;

  const PersonaIntroData({
    required this.name,
    required this.category,
    required this.actionLabel,
    required this.icon,
    required this.accentColor,
  });
  
  @override
  List<Object?> get props => [name,category,actionLabel,icon,accentColor];
}