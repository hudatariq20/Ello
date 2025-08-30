import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/shared/models/personaTheme_model.dart';

final personaThemeProvider =
    NotifierProvider<PersonaThemeNotifier, PersonaTheme>(
        PersonaThemeNotifier.new);

class PersonaThemeNotifier extends Notifier<PersonaTheme> {
  @override
  PersonaTheme build() {
    // Default to Zen
    return const PersonaTheme(
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
      voiceId: 'TxGEqnHWrfWFTfGW9XjX', // Rachel - default voice
      voiceStability: 0.15,
      voiceSimilarity: 0.75,
    );
  }

  void setPersona(String personaName) {
    switch (personaName) {
      case 'Zen':
        state = const PersonaTheme(
          gradientColors: [
            Color(0xFFE5CDFF),
            Color(0xFFD0D9FF),
            Color(0xFFB6E5FF),
          ],
          appBarColor: Color(0xFFE5CDFF),
          appBarIconColor: Color(0xFF8F54FF),
          seedColor: Color(0xFFE5CDFF), // Zen
          buttonColors: [
            Color(0xFFE858FF),
            Color(0xFF8F54FF),
            Color(0xFF4E9FFF),
          ],
          voiceId:
              'TxGEqnHWrfWFTfGW9XjX', // Josh , Calm soothing mindful voice.
          voiceStability: 0.2,
          voiceSimilarity: 0.8,
        );
        break;
      case 'Spark':
        state = const PersonaTheme(
          gradientColors: [
            Color(0xFFFFB74D),
            Color.fromARGB(255, 255, 184, 163),
            Color(0xFFFFCC80),
          ],
          appBarColor: Color(0xFFFFB74D),
          appBarIconColor: Color(0xFFE65100),
          seedColor: Color(0xFFFFB74D),
          buttonColors: [
            Color(0xFFFFB74D),
            Color(0xFFFF8A65),
            Color(0xFFFFCC80),
          ],
          voiceId: 'ErXwobaYiN019PkySvjV', // Josh - energetic voice
          voiceStability: 0.1,
          voiceSimilarity: 0.7,
        );
        break;
      case 'Sage':
        state = const PersonaTheme(
          gradientColors: [
            Color.fromARGB(255, 197, 178, 171),
            Color.fromARGB(255, 209, 180, 170),
            Color(0xFFA1887F),
          ],
          appBarColor: Color(0xFF8D6E63),
          appBarIconColor: Color(0xFF4E342E),
          seedColor: Color(0xFF8D6E63),
          buttonColors: [
            Color(0xFF8D6E63),
            Color(0xFF6D4C41),
            Color(0xFFA1887F),
          ],
          voiceId: 'MF3mGyEYCl7XYWbV9V6O', // Elli - mature voice
          voiceStability: 0.25,
          voiceSimilarity: 0.85,
        );
        break;
      case 'Nova':
      default:
        state = const PersonaTheme(
          gradientColors: [
            Color(0xFFBBDEFB),
            Color(0xFFD1E7F3),
            Color(0xFFA7D5F4)
            // Color(0xFFBBDEFB),
            // Color.fromARGB(255, 189, 215, 235),
            // Color.fromARGB(255, 122, 177, 222),
          ],
         // appBarColor: Color(0xFF42A5F5),
         appBarColor:  Color(0xFFD1E7F3),
          appBarIconColor: Color(0xFF1565C0),
          seedColor: Color(0xFF42A5F5),
          buttonColors: [
            Color(0xFF90CAF9),
            Color(0xFF2196F3),
            Color(0xFF1E88E5),
          ],
          voiceId: '21m00Tcm4TlvDq8ikWAM', // Rachel - default voice
          voiceStability: 0.15,
          voiceSimilarity: 0.75,
        );
        break;
    }
  }
}
