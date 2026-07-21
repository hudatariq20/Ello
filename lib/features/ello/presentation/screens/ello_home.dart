import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/providers/assistant_provider.dart';
import 'package:voice_input/shared/screens/temp_sign_out.dart';
import 'package:voice_input/shared/widgets/assistant_wake_word.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

class ElloHomeScreen extends ConsumerStatefulWidget {
  const ElloHomeScreen({super.key});

  @override
  ConsumerState<ElloHomeScreen> createState() => _ElloHomeScreenState();
}

class _ElloHomeScreenState extends ConsumerState<ElloHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  final starterChips = StarterChips(
    chipPhrase: const [
      "Plan with Nova",
      "Journal with Zen",
      "Brainstorm with Spark",
      "Query about your child with Sage",
    ],
    onChipSelected: (phrase) {
      // Use your voice assistant logic or OpenAI function call
      debugPrint("Chip tapped: $phrase");
      // Optionally: sendToNova(phrase); or ref.read(chatProvider).send(phrase)
    },
  );

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

    return GradientBackground(
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
              leading: const SignOutButton(),
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
              //chips for the home screen
              Visibility(
                visible: !isSpeechListening,
                child: starterChips,
              ),
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
    );
  }
}
