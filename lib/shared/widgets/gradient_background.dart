
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/shared/theme/persona_theme_model.dart';
import 'package:voice_input/shared/providers/persona_theme_provider.dart';

class GradientBackground extends ConsumerWidget {
  final Widget child;

  /// Optional explicit theme. When supplied, this is used instead of
  /// watching [personaThemeProvider] — for screens (like the Ello shell)
  /// whose background must stay fixed regardless of the globally selected
  /// persona.
  final PersonaTheme? themeOverride;

  const GradientBackground({super.key, required this.child, this.themeOverride});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PersonaTheme theme =
        themeOverride ?? ref.watch(personaThemeProvider);

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.0, 0.8, 1.0],
          colors: theme.gradientColors,
        ),
      ),
      child:
          child, // The child widget that will be displayed inside the gradient
    );
  }
}
// class GradientBackground extends StatelessWidget {
//   final Widget child;

//   const GradientBackground({super.key, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           stops: [0.0, 0.8, 1.0],
//           colors: [
//             //GRADIENTS FOR ZEN...
//             // Color(0xFFE5CDFF), //PURPLE COLOR
//             // Color(0xFFD0D9FF), //TRANSITION COLOR
//             // Color(0xFFB6E5FF), //FINAL BLUE COLOUR

//             //GRADIENTS FOR NOVA...
//             Color(0xFF42A5F5),
//             Color(0xFF64B5F6),
//             Color(0xFFBBDEFB), // Light pastel blue (Top)
//              // Mid transition color (Middle)

//           ],
//         ),
//       ),
//       child:
//           child, // The child widget that will be displayed inside the gradient
//     );
//   }
// }
