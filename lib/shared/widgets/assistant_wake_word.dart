import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/shared/screens/screens.dart';
import '../../providers/assistant_provider.dart';
import 'package:voice_input/shared/services/services.dart';

class AssistantWakeWord extends ConsumerStatefulWidget {
  final Function(String) onSpeechDetected;
  final Function() onError;

  const AssistantWakeWord({
    super.key,
    required this.onSpeechDetected,
    required this.onError,
  });

  @override
  ConsumerState<AssistantWakeWord> createState() => _AssistantWakeWordState();
}

class _AssistantWakeWordState extends ConsumerState<AssistantWakeWord>
    with SingleTickerProviderStateMixin {
  late AnimationController _gradientController;
  late Animation<Offset> _bounceAnimation;
  late Animation<double> _pulseAnimation;
  late PorcupineService _porcupineService;
  final SpeechHandler _speechHandler = SpeechHandler();

  //String transcribedText = "";

  @override //intialize gradient controller, pulse animation, bounce animation
  //and initialize the wake word flow
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );
    _bounceAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.2),
    ).animate(
      CurvedAnimation(
        parent: _gradientController,
        curve: Curves.easeInOut,
      ),
    );
    _initializeWakeWordFlow(); //INITIALIZE THE WAKE WORD FLOW
    //-> SPEECH HANDLER, PORCUPINE SERVICE, AND GRADIENT CONTROLLER
  }

  Future<void> _initializeWakeWordFlow() async {
    try {
      await _speechHandler.initSpeech(); //INITIALIZE THE SPEECH HANDLER

      _porcupineService = PorcupineService(
        //AFTER porcupine service it will call the onWakeWordDetected function
        onWakeWordDetected: (index) async {
          if (index == 0) {
            ref.read(assistantProvider.notifier).setWakeWordListening(false);
            await _handleVoiceFlow(); //START THE SPEECH RECOGNITION - LISTENING FOR SPEECH - ON THE MICROPHONE
          }
        },
      );

      await _porcupineService.init(); //INITIALIZE THE PORCUPINE SERVICE
      await _porcupineService.startListening(); //START LISTENING FOR WAKE WORD
      ref
          .read(assistantProvider.notifier)
          .setWakeWordListening(true); //SET WAKE WORD LISTENING TO TRUE
      _gradientController.repeat(reverse: true); //REPEAT THE PULSE ANIMATION
    } catch (e) {
      widget.onError();
    }
  }

  Future<void> _handleVoiceFlow() async {
    final speech = _speechHandler;

    if (speech.speech.isListening) {
      await speech.stopListening();
      ref.read(assistantProvider.notifier).setSpeechListening(false);
      ref.read(assistantProvider.notifier).setTranscribedText("");
    } else {
      try {
        ref.read(assistantProvider.notifier).setSpeechListening(true);
        final result = await speech.startListening();
        ref.read(assistantProvider.notifier).setSpeechListening(false);
        if (result.isNotEmpty) {
          widget.onSpeechDetected(result);
          ref.read(assistantProvider.notifier).setTranscribedText(result);

          // Show transcribed text, wait 2s, then navigate
          //pass the intial text to chat screen but first go to persona screen
          Future.delayed(const Duration(seconds: 2), () {
            if (!mounted) return;
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              //builder: (context) => ChatScreen(initialText: result),
              builder: (context) => PersonaPresets(initialText: result),
            ));
          });
        }
      } catch (e) {
        ref.read(assistantProvider.notifier).setSpeechListening(false);
        widget.onError();
      }
    }
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _porcupineService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assistantState = ref.watch(assistantProvider);
    final transcribedText = ref.watch(assistantProvider).transcribedText;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (assistantState.isSpeechListening || transcribedText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              transcribedText,
              //transcribedText.isNotEmpty ? transcribedText : 'Listening...',
              style: GoogleFonts.urbanist(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        // if (!assistantState.isSpeechListening &&
        //     transcribedText.isEmpty &&
        //     assistantState.isWakeWordListening)
        //   Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Center(
        //       child: Text(
        //         'Say ‘Hey Ello’ &\nWho Do you want to chat with!',
        //         style: GoogleFonts.urbanist(
        //           fontSize: 20,
        //           fontWeight: FontWeight.w600,
        //           color: Theme.of(context).colorScheme.primary,
        //         ),
        //       ),
        //     ),
        //   ),
        const SizedBox(height: 30),
        Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: assistantState.isSpeechListening ||
                  assistantState.transcribedText.isNotEmpty,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/chat_ui.png'), // Replace with your image path
                      fit: BoxFit
                          .contain, // You can adjust the fit based on how you want the image to scale
                    ),
                  ),
                  // child: const Icon(Icons.mic, color: Colors.white, size: 28),
                ),
              ),
            ),
            const SizedBox(width: 25),
            Center(
              child: GestureDetector(
                onTap: _handleVoiceFlow,
                child: AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFE858FF)
                                .withOpacity(_pulseAnimation.value),
                            Color(0xFF8F54FF)
                                .withOpacity(_pulseAnimation.value),
                            Color(0xFF4E9FFF)
                                .withOpacity(_pulseAnimation.value),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                      child: Center(
                        child: assistantState.isSpeechListening
                            ? SlideTransition(
                                position: _bounceAnimation,
                                child: const Icon(Icons.more_horiz,
                                    color: Colors.white, size: 28),
                              )
                            : const Icon(Icons.mic,
                                color: Colors.white, size: 28),
                        //child: Icon(assistantState.isSpeechListening ? Icons.more_horiz : Icons.mic, color: Colors.white, size: 28),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 25),
            Visibility(
              visible: assistantState.isSpeechListening ||
                  assistantState.transcribedText.isNotEmpty,
              child: GestureDetector(
                onTap: () {
                  ref
                      .read(assistantProvider.notifier)
                      .setSpeechListening(false); //stop the speech listening
                  ref
                      .read(assistantProvider.notifier)
                      .setTranscribedText(""); //clear the transcribed text
                  //clear the porcupine service
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Icon(Icons.close,
                      color: Theme.of(context).colorScheme.primary, size: 28),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
