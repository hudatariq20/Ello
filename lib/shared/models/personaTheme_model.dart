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

const PersonaTheme zenPersonaTheme = PersonaTheme(
  gradientColors: [
    Color(0xFFE5CDFF),
    Color(0xFFD0D9FF),
    Color(0xFFB6E5FF),
  ],
  appBarColor: Color(0xFFE5CDFF),
  appBarIconColor: Color(0xFF8F54FF),
  seedColor: Color(0xFFE5CDFF),
  buttonColors: [
    Color(0xFFE858FF),
    Color(0xFF8F54FF),
    Color(0xFF4E9FFF),
  ],
  voiceId: 'TxGEqnHWrfWFTfGW9XjX', // Josh, calm soothing mindful voice.
  voiceStability: 0.2,
  voiceSimilarity: 0.8,
);
