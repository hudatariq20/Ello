import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/shared/theme/persona_presets.dart';
import 'package:voice_input/shared/theme/persona_theme_model.dart';
import 'package:voice_input/shared/theme/persona_type.dart';

final personaThemeProvider =
    NotifierProvider<PersonaThemeNotifier, PersonaTheme>(
  PersonaThemeNotifier.new,
);

class PersonaThemeNotifier extends Notifier<PersonaTheme> {
  @override
  PersonaTheme build() {
    return personaThemes[PersonaType.zen]!;
  }

  void setPersona(PersonaType persona) {
    state = personaThemes[persona]!;
  }
}