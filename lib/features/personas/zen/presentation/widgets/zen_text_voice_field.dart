import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/features/personas/zen/presentation/widgets/zen_widgets.dart';
import 'package:voice_input/shared/models/message_model.dart';
import 'package:voice_input/providers/providers.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/services/services.dart';
import 'package:google_fonts/google_fonts.dart';

enum ZenInputMode { voice, text }

class ZenTextAndVoice extends ConsumerStatefulWidget {
  final String? persona; //persona check
  const ZenTextAndVoice({super.key, this.persona});

  @override
  ConsumerState<ZenTextAndVoice> createState() => _ZenTextAndVoiceState();
}

class _ZenTextAndVoiceState extends ConsumerState<ZenTextAndVoice> {
  ZenInputMode _inputMode =
      ZenInputMode.voice; //check what mode of input is needed
  final _messageController = TextEditingController(); //message controller
  OpenAIService _openAIService =
      OpenAIService(); // XXXXXopenai service to send messages, would not be required in this case
  SpeechHandler _speechHandler =
      SpeechHandler(); //speech handler to take voice input
  TTSHandler _ttsHandler =
      TTSHandler(); // XXXX would not be required in this case
  bool _isTyping = false; // XXX may be not needed
  bool _isMicEnabled = true; // XXX may be not needed

  @override
  void initState() {
    _speechHandler.initSpeech();
    _ttsHandler.initTextToSpeech();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _ttsHandler.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(personaThemeProvider);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _messageController,
            onChanged: (value) {
              value.isNotEmpty
                  ? setInputState(ZenInputMode.text)
                  : setInputState(ZenInputMode.voice);
            },
            cursorColor: Theme.of(context).colorScheme.surface,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Tap or speak to add entry...',
              hintStyle: GoogleFonts.urbanist(
                color: const Color(0xFF5A2F9E),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                ),
              ),
            ),
          )),
          const SizedBox(
            width: 06,
          ),
          ZenVoiceOrSendButton(
            isReplying: _isTyping,
            inputMode: _inputMode,
            isListening: _isMicEnabled,
            incomingtextMessage: () {
              final textMessage = _messageController.text;
              _messageController.clear();
              sendTextMessage(textMessage);
            },
            incomingvoiceMessge: sendVoiceMessage,
          )
        ],
      ),
    );
  }

  void setInputState(ZenInputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  void sendVoiceMessage() async {
    if (_speechHandler.speech.isListening) {
      await _speechHandler.stopListening();
      setMicState(false);
    } else {
      setMicState(true);
      final result = await _speechHandler.startListening();
      //setMicState(false);
      sendTextMessage(result);
    }
  }

  void sendTextMessage(String message) async {
    setReplyingState(true);
    addtoChatList(message, true, DateTime.now().toString());
    setInputState(ZenInputMode.voice);
    final chats = ref.read(ChatProvider.notifier);
    chats.add(
        const MessageModel(id: 'bot', message: 'Replying..', isUser: false));

    final aiResponse = await _openAIService.ChatGPTAPI(message);
    //eliminateReplyStatus();
    addtoChatList(aiResponse, false,
        DateTime.now().toString()); // Immediate feedback to user
    // Re-set voice settings before speaking
    final personaTheme = ref.read(personaThemeProvider);
    if (personaTheme != null) {
      debugPrint('Setting voice before speaking: ${personaTheme.voiceId}');
      _ttsHandler.setVoiceFromPersona(personaTheme);
    }
    Future.microtask(
        () => _ttsHandler.playTextToSpeech(aiResponse)); // Non-blocking
    setReplyingState(false);
  }

  void addtoChatList(String message, bool isUser, String id) {
    final chats = ref.read(ChatProvider.notifier);
    chats.add(MessageModel(
        id: DateTime.now().toString(), message: message, isUser: isUser));
  }

  void setReplyingState(bool isTyping) {
    setState(() {
      //_isTyping = isTyping;
    });
  }

  void setMicState(bool micEnabled) {
    setState(() {
      _isMicEnabled = micEnabled;
    });
  }
}
