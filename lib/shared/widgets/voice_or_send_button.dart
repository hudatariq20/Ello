import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/providers/providers.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

class VoiceOrSendButton extends ConsumerStatefulWidget {
  final VoidCallback _incomingtextMessage;
  final VoidCallback _incomingvoiceMessage;
  final InputMode _inputMode;
  final bool _isReplying;
  final bool _isListening;
  const VoiceOrSendButton(
      {super.key,
      required InputMode inputMode,
      required VoidCallback incomingtextMessage,
      required VoidCallback incomingvoiceMessge,
      required bool isReplying,
      required bool isListening})
      : _inputMode = inputMode,
        _incomingtextMessage = incomingtextMessage,
        _incomingvoiceMessage = incomingvoiceMessge,
        _isReplying = isReplying,
        _isListening = isListening;

  @override
  ConsumerState<VoiceOrSendButton> createState() => _VoiceOrSendButtonState();
}

class _VoiceOrSendButtonState extends ConsumerState<VoiceOrSendButton> {
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(personaThemeProvider);
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(2.0)),
        onPressed: widget._isReplying
            ? null
            : widget._inputMode == InputMode.text
                ? widget._incomingtextMessage
                : widget._incomingvoiceMessage,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.buttonColors[0],
                theme.buttonColors[1],
                theme.buttonColors[2],
                //zen
                // Color(0xFFE858FF),
                // Color(0xFF8F54FF),
                // Color(0xFF4E9FFF),
                //nova
                // Color(0xFF90CAF9), // Darker version of BBDEFB
                // Color(0xFF2196F3), // Darker version of 64B5F6
                // Color(0xFF1E88E5), // Darker version of 42A5F5
              ],
            ),
          ),
          child: Icon(
            widget._inputMode == InputMode.text
                ? Icons.send
                : widget._isListening
                    ? Icons.mic
                    : Icons.mic_off,
            color: Colors.white,
            size: 30,
          ),
        ));
  }
}
