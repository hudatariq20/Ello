import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/providers/assistant_provider.dart';
import 'package:voice_input/shared/models/personaTheme_model.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

class ElloScreen extends ConsumerStatefulWidget {
  const ElloScreen({super.key});

  @override
  ConsumerState<ElloScreen> createState() => _ElloScreenState();
}

class _ElloScreenState extends ConsumerState<ElloScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _handleSpeechDetected(String text) {
    print("Speech detected: $text");
  }

  void _handleError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed to initialize voice assistant'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assistantState = ref.watch(assistantProvider);
    final isSpeechListening = ref.watch(assistantProvider).isSpeechListening;

    // Home is visually fixed to the Zen theme regardless of the globally
    // selected persona. This only overrides colors/text for this subtree —
    // it does not touch personaThemeProvider, so the persona state driving
    // TTS voice selection and the persona screens is untouched.
    final homeThemeData = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: zenPersonaTheme.gradientColors.first,
        brightness: Brightness.light,
      ),
      appBarTheme: Theme.of(context).appBarTheme.copyWith(
            backgroundColor: zenPersonaTheme.appBarColor,
            foregroundColor: zenPersonaTheme.appBarIconColor,
            titleTextStyle: GoogleFonts.urbanist(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: zenPersonaTheme.appBarIconColor,
            ),
          ),
    );

    return Theme(
      data: homeThemeData,
      child: GradientBackground(
        themeOverride: zenPersonaTheme,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: AnimatedOpacity(
              opacity: isSpeechListening ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: AppBar(
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: const Text('Ello'),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // 👈 KEY LINE
              children: [
                Visibility(
                  visible: !isSpeechListening,
                  child: ZoomIn(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 10)
                            .copyWith(top: 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20)
                              .copyWith(topLeft: Radius.zero),
                        ),
                        child: Text(
                          'Hello! I\'m ELLO, your AI assistant',
                          style: GoogleFonts.urbanist(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -50 * _controller.value),
                        child: SizedBox(
                          //height: 200,
                          child: child,
                        ),
                      );
                    },
                    child: Lottie.asset(
                      'assets/images/AI.json',
                      repeat: true,
                      fit: BoxFit.contain,
                      onLoaded: (composition) {
                        debugPrint(
                            "✅ Lottie loaded with duration: ${composition.duration}");
                      },
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                ZoomIn(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: AssistantWakeWord(
                      onSpeechDetected: _handleSpeechDetected,
                      onError: _handleError,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
