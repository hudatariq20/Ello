import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PersonaTheme extends Equatable {
  final List<Color> gradientColors;
  final Color appBarColor;
  final Color appBarIconColor;
  final Color seedColor;
  final List<Color> buttonColors;

  final String voiceId;
  final double voiceStability;
  final double voiceSimilarity;

  const PersonaTheme({
    required this.gradientColors,
    required this.appBarColor,
    required this.appBarIconColor,
    required this.seedColor,
    required this.buttonColors,
    required this.voiceId,
    this.voiceStability = 0.15,
    this.voiceSimilarity = 0.75,
  });

  @override
  List<Object?> get props => [
        gradientColors,
        appBarColor,
        appBarIconColor,
        seedColor,
        buttonColors,
        voiceId,
        voiceStability,
        voiceSimilarity,
      ];
}