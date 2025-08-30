import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/shared/models/message_model.dart';
import 'package:voice_input/providers/providers.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/services/services.dart';
import 'package:voice_input/shared/widgets/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

enum InputMode { voice, text }

class TextAndVoice extends ConsumerStatefulWidget {
  final String? persona;
  const TextAndVoice({super.key, this.persona});

  @override
  ConsumerState<TextAndVoice> createState() => _TextAndVoiceState();
}

class _TextAndVoiceState extends ConsumerState<TextAndVoice> {
  InputMode _inputMode = InputMode.voice;
  final _messageController = TextEditingController();
  OpenAIService _openAIService = OpenAIService();
  SpeechHandler _speechHandler = SpeechHandler();
  TTSHandler _ttsHandler = TTSHandler();
  bool _isTyping = false;
  bool _isMicEnabled = true;

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

  void eliminateReplyStatus() {
    final chats = ref.read(ChatProvider.notifier);
    chats.removeStatus();
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
                  ? setInputState(InputMode.text)
                  : setInputState(InputMode.voice);
            },
            cursorColor: Theme.of(context).colorScheme.surface,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Ask me anything...',
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: const [0.9, 1.0],
                      colors: [
                        Theme.of(context).colorScheme.primaryContainer,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: IconButton(
                    // icon: const Icon(Icons.add, color: Color(0xFF8F54FF)),
                    icon: Icon(
                      Icons.add,
                      color: theme.appBarIconColor,
                    ),
                    //const Icon(Icons.add, color: Color(0xFF1565C0)), //NOVA
                    onPressed: () {
                      // Add your button action hereR
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
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
          VoiceOrSendButton(
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

  void setInputState(InputMode inputMode) {
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
    setInputState(InputMode.voice);
    final chats = ref.read(ChatProvider.notifier);
    chats.add(
        const MessageModel(id: 'bot', message: 'Replying..', isUser: false));

    final aiResponse = await _openAIService.ChatGPTAPI(message);
    eliminateReplyStatus();
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
      _isTyping = isTyping;
    });
  }

  void setMicState(bool micEnabled) {
    setState(() {
      _isMicEnabled = micEnabled;
    });
  }
}
