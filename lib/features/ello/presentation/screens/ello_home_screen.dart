import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/shared/providers/persona_theme_provider.dart';
import 'package:voice_input/shared/theme/persona_presets.dart';
import 'package:voice_input/shared/theme/persona_type.dart';
import 'package:voice_input/shared/widgets/gradient_background.dart';

import '../widgets/ello_widgets.dart';

class ElloHome extends ConsumerWidget {
  const ElloHome({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                const Center(
                  child: ElloAssistantOrb(),
                ),
                const SizedBox(height: 10),
                Text(
                  'Your Assistants',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 14),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                  children: [
                    PersonaStatusCard(
                      persona: 'Nova',
                      categoryLabel: 'Tasks & Reminders',
                      summary: 'Start with Nova',
                      icon: Icons.check_circle_outline,
                      accentColor: const Color(0xFF42A5F5),
                      onTap: () {
                        _openPersona(context, ref, 'Nova');
                      },
                    ),
                    PersonaStatusCard(
                      persona: 'Zen',
                      categoryLabel: 'Journaling',
                      summary: 'Start a journal',
                      icon: Icons.self_improvement,
                      accentColor: const Color(0xFF8F54FF),
                      onTap: () {
                        _openPersona(context, ref, 'Zen');
                      },
                    ),
                    PersonaStatusCard(
                      persona: 'Spark',
                      categoryLabel: 'Planning',
                      summary: 'Plan your week',
                      icon: Icons.flash_on,
                      accentColor: const Color(0xFFFF8A65),
                      onTap: () {
                        _openPersona(context, ref, 'Spark');
                      },
                    ),
                    PersonaStatusCard(
                      persona: 'Sage',
                      categoryLabel: 'Learning',
                      summary: 'Ask Sage anything',
                      icon: Icons.school_outlined,
                      accentColor: const Color(0xFF8D6E63),
                      onTap: () {
                        _openPersona(context, ref, 'Sage');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar:  ElloBottomNavigation(
          backgroundColor: zenPersonaTheme.appBarColor,
          iconColor: zenPersonaTheme.appBarIconColor,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // speech logic later
          },
          shape: const CircleBorder(),
          backgroundColor: zenPersonaTheme.appBarColor,
          foregroundColor: Colors.white,
          child: const Icon(Icons.mic),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Huda',
                style: GoogleFonts.urbanist(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
              ),
              const SizedBox(height: 4),
              Text(
                'Continue where you left off',
                style: GoogleFonts.urbanist(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
              ),
            ],
          ),
        ),
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
    ref.read(personaThemeProvider.notifier).setPersona(PersonaType.nova);

    switch (persona) {
      case 'Nova':
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => const NovaHubScreen(),
        //   ),
        // );
        break;

      case 'Zen':
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) =>
        //         const ZenFeelingChatScreen(persona: 'Zen'),
        //   ),
        // );
        break;

      case 'Spark':
        // Add Spark destination.
        break;

      case 'Sage':
        // Add Sage destination.
        break;
    }
  }
}
