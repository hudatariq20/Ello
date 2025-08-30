import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/personas/zen/presentation/screens/zen_screens.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/screens/screens.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

class PersonaPresets extends StatefulWidget {
  final String initialText;
  const PersonaPresets({super.key, required this.initialText});

  @override
  State<PersonaPresets> createState() => _PersonaPresetsState();
}

class _PersonaPresetsState extends State<PersonaPresets> {
  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text('Choose your Assistant'),
        ),
        body: Consumer(
          builder: (context, ref, _) {
            return GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              padding: const EdgeInsets.all(16),
              children: [
                GlassCard(
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(personaThemeProvider.notifier)
                          .setPersona('Nova');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            initialText: widget.initialText,
                            persona: 'Nova',
                          ),
                        ),
                      );
                    },
                    child: const PersonaCard(
                      icon: Icons.person_outline,
                      title: 'Nova',
                      subtitle: 'Helpful',
                      gradientColors: [
                        Color(0xFF42A5F5),
                        Color(0xFF64B5F6),
                        Color(0xFFBBDEFB),
                      ],
                    ),
                  ),
                ),
                GlassCard(
                  child: InkWell(
                    onTap: () {
                      ref.read(personaThemeProvider.notifier).setPersona('Zen');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ZenFeelingChatScreen(
                            persona: 'Zen',
                          ),
                        ),
                      );
                    },
                    child: const Hero(
                      tag: 'ZenHero',
                      child: PersonaCard(
                        icon: Icons.self_improvement,
                        title: 'Zen',
                        subtitle: 'Mindful',
                        gradientColors: [
                          Color(0xFFE858FF),
                          Color(0xFF8F54FF),
                          Color(0xFF4E9FFF),
                        ],
                      ),
                    ),
                  ),
                ),
                GlassCard(
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(personaThemeProvider.notifier)
                          .setPersona('Spark');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            initialText: widget.initialText,
                            persona: 'Spark',
                          ),
                        ),
                      );
                    },
                    child: const PersonaCard(
                      icon: Icons.flash_on,
                      title: 'Spark',
                      subtitle: 'Energetic',
                      gradientColors: [
                        Color(0xFFFFB74D),
                        Color(0xFFFF8A65),
                        Color(0xFFFFCC80),
                      ],
                    ),
                  ),
                ),
                GlassCard(
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(personaThemeProvider.notifier)
                          .setPersona('Sage');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            initialText: widget.initialText,
                            persona: 'Sage',
                          ),
                        ),
                      );
                    },
                    child: const PersonaCard(
                      icon: Icons.school,
                      title: 'Sage',
                      subtitle: 'Wise',
                      gradientColors: [
                        Color(0xFF8D6E63),
                        Color(0xFF6D4C41),
                        Color(0xFFA1887F),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
