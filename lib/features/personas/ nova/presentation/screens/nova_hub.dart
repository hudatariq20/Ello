import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/personas/%20nova/presentation/providers/nova_tasks_provider.dart';
import 'package:voice_input/shared/models/shared_models.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/widgets/gradient_background.dart';
import '../../data/datasources/nova_datasources.dart';
import '../widgets/nova_widgets.dart';

class NovaHubScreen extends ConsumerStatefulWidget {
  const NovaHubScreen({super.key});

  @override
  ConsumerState<NovaHubScreen> createState() => _NovaHubState();
}

class _NovaHubState extends ConsumerState<NovaHubScreen> {
  //redirection tiles,
  List<PersonaRedirection> redirectionTiles = NovaRedirectionSource.getTiles();
  @override
  Widget build(BuildContext context) {
    var theme = ref.watch(personaThemeProvider);
    final tasksAsync = ref.watch(novaTasksProvider);
    return GradientBackground(
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                HubList(theme: theme, tasksAsync: tasksAsync),
                NovaRedirectionList(theme: theme, redirectionTiles: redirectionTiles),
                const SizedBox(height: 5),
                const NovaMic(
                  width: 60,
                  height: 60,
                  micColor: Colors.blueAccent,
                  gradientColors: [
                    Colors.white,
                    Colors.white,
                ],),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// class PersonaRedirection {
//   final IconData icon;
//   final String title;
//   final String subtitle;
//   final List<Color> gradientColors;

//   PersonaRedirection(
//       {required this.icon,
//       required this.title,
//       required this.subtitle,
//       required this.gradientColors});
// }

// List<PersonaRedirection> redirectionTiles = [
//   PersonaRedirection(
//     icon: Icons.person_outline,
//     title: "Nova",
//     subtitle: "Helpful",
//     gradientColors: [
//       Color(0xFF42A5F5),
//       Color(0xFF64B5F6),
//       Color(0xFFBBDEFB),
//     ],
//   ),
//   PersonaRedirection(
//     icon: Icons.self_improvement,
//     title: "Zen",
//     subtitle: "Mindful",
//     gradientColors: [
//       Color(0xFFE858FF),
//       Color(0xFF8F54FF),
//       Color(0xFF4E9FFF),
//     ],
//   ),
//   PersonaRedirection(
//     icon: Icons.flash_on,
//     title: "Spark",
//     subtitle: "Energetic",
//     gradientColors: [
//       Color(0xFFFFB74D),
//       Color(0xFFFF8A65),
//       Color(0xFFFFCC80),
//     ],
//   ),
//   PersonaRedirection(
//     icon: Icons.school,
//     title: "Sage",
//     subtitle: "Wise",
//     gradientColors: [
//       Color(0xFF8D6E63),
//       Color(0xFF6D4C41),
//       Color(0xFFA1887F),
//     ],
//   ),
// ];

