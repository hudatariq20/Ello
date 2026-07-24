import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voice_input/features/ello/presentation/models/ello_intro_data.dart';
import 'package:voice_input/shared/providers/persona_theme_provider.dart';
import 'package:voice_input/shared/theme/persona_presets.dart';
import 'package:voice_input/shared/theme/persona_type.dart';
import 'package:voice_input/shared/widgets/gradient_background.dart';

import '../widgets/ello_widgets.dart';

class ElloHomeScreenNewUser extends ConsumerWidget {
  const ElloHomeScreenNewUser({super.key});

  static const List<ElloIntroData> _personas = [
  ElloIntroData(
    type: PersonaType.nova,
    category: 'Tasks & Reminders',
    actionLabel: 'Start with Nova',
    icon: Icons.check_circle_outline,
  ),
  ElloIntroData(
    type: PersonaType.zen,
    category: 'Journaling',
    actionLabel: 'Start a journal',
    icon: Icons.self_improvement,
  ),
  ElloIntroData(
    type: PersonaType.spark,
    category: 'Planning',
    actionLabel: 'Plan your week',
    icon: Icons.flash_on,
  ),
  ElloIntroData(
    type: PersonaType.sage,
    category: 'Learning',
    actionLabel: 'Ask Sage anything',
    icon: Icons.school_outlined,
  ),
];


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientBackground(
      themeOverride: zenPersonaTheme,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              children: [
                _buildHeader(context),
                const SizedBox(height: 28),
                Text(
                  'What would you like help with today?',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'I can help you with tasks, journaling, planning, and learning.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 26),
                const ElloAssistantOrb(),
                const SizedBox(height: 6),
                Text(
                  'Tap the microphone to speak',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Here’s what you can do',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 132,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _personas.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final ElloIntroData persona = _personas[index];

                      return SizedBox(
                        width: 100,
                        child: ElloIntroCard(
                          data: persona,
                          onTap: () {
                            _openPersona(
                              context,
                              ref,
                              persona.type,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ElloBottomNavigation(
          backgroundColor: zenPersonaTheme.appBarColor,
          iconColor: zenPersonaTheme.appBarIconColor,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Connect the speech flow later.
          },
          shape: const CircleBorder(),
          backgroundColor: zenPersonaTheme.buttonColors.first,
          foregroundColor: Colors.white,
          child: const Icon(Icons.mic),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Text(
          'Ello',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  void _openPersona(
    BuildContext context,
    WidgetRef ref,
    PersonaType persona,
  ) {
    ref.read(personaThemeProvider.notifier).setPersona(persona);

    switch (persona) {
      case PersonaType.nova:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => const NovaHubScreen(),
        //   ),
        // );
        break;

      case PersonaType.zen:
        // Navigate to Zen.
        break;

      case PersonaType.spark:
        // Navigate to Spark.
        break;

      case PersonaType.sage:
        // Navigate to Sage.
        break;
    }
  }
}