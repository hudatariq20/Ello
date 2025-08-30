import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/personas/zen/presentation/widgets/zen_widgets.dart';
import 'package:voice_input/providers/providers.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

class ZenVoiceOrSendButton extends ConsumerStatefulWidget {
  final VoidCallback _incomingtextMessage;
  final VoidCallback _incomingvoiceMessage;
  final ZenInputMode _inputMode;
  final bool _isReplying; //maybe not needed
  final bool _isListening;
  const ZenVoiceOrSendButton(
      {super.key,
      required ZenInputMode inputMode,
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
  ConsumerState<ZenVoiceOrSendButton> createState() =>
      _ZenVoiceOrSendButtonState();
}

class _ZenVoiceOrSendButtonState extends ConsumerState<ZenVoiceOrSendButton> {
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
