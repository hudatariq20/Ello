import 'package:flutter/material.dart';

class PersonaTheme {
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
}
