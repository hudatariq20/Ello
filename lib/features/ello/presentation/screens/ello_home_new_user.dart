import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/widgets/gradient_background.dart';

import '../../../../shared/models/shared_models.dart';
import '../../data/ello_models.dart';
import '../widgets/ello_widgets.dart';

class ElloHomeScreenNewUser extends ConsumerWidget {
  const ElloHomeScreenNewUser({super.key});

  static const _personas = <PersonaIntroData>[
    PersonaIntroData(
      name: 'Nova',
      category: 'Tasks & Reminders',
      actionLabel: 'Start with Nova',
      icon: Icons.check_circle_outline,
      accentColor: Color(0xFF42A5F5),
    ),
    PersonaIntroData(
      name: 'Zen',
      category: 'Journaling',
      actionLabel: 'Start a journal',
      icon: Icons.self_improvement,
      accentColor: Color(0xFF8F54FF),
    ),
    PersonaIntroData(
      name: 'Spark',
      category: 'Planning',
      actionLabel: 'Plan your week',
      icon: Icons.flash_on,
      accentColor: Color(0xFFFF8A65),
    ),
    PersonaIntroData(
      name: 'Sage',
      category: 'Learning',
      actionLabel: 'Ask Sage anything',
      icon: Icons.school_outlined,
      accentColor: Color(0xFF8D6E63),
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
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _personas.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final persona = _personas[index];

                    return PersonaIntroCard(
                      data: persona,
                      onTap: () {
                        _openPersona(
                          context,
                          ref,
                          persona.name,
                        );
                      },
                    );
                  },
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
            // Speech flow will be connected later.
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
    String persona,
  ) {
    ref.read(personaThemeProvider.notifier).setPersona(persona);

    switch (persona) {
      case 'Nova':
        // Navigate to Nova.
        break;
      case 'Zen':
        // Navigate to Zen.
        break;
      case 'Spark':
        // Navigate to Spark.
        break;
      case 'Sage':
        // Navigate to Sage.
        break;
    }
  }
}