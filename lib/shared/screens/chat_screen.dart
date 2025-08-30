import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/shared/models/message_model.dart';
import 'package:voice_input/providers/providers.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/services/services.dart';
import 'package:voice_input/shared/widgets/widgets.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String? initialText;
  final String? persona;
  const ChatScreen({super.key, this.initialText, this.persona});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  bool _hasAddedInitialText = false;
  final OpenAIService _openAIService =
      OpenAIService(); //need it for the chatbot response initially
  late TTSHandler _ttsHandler;
  bool _isTyping = false;
  late ChatStreamProcessor _processor; //for the chatbot response

  void setReplyingState(bool isTyping) {
    setState(() {
      _isTyping = isTyping;
    });
  }

  void eliminateReplyStatus() {
    final chats = ref.read(ChatProvider.notifier);
    chats.removeStatus();
  }

  @override
  void initState() {
    super.initState();
    // _processor = ChatStreamProcessor(
    //   onPartialUpdate: (text) {
    //     final chats = ref.read(ChatProvider.notifier);
    //     chats.updateLastAssistantMessage(text); // shows live updates
    //   },
    //   onSentenceReady: (sentence) async {
    //     final chats = ref.read(ChatProvider.notifier);
    //     chats.add(MessageModel(
    //       id: DateTime.now().toString(),
    //       message: sentence,
    //       isUser: false,
    //     )); // solidify completed sentence
    //     await _ttsHandler
    //         .playTextToSpeech(sentence); // speak each complete sentence
    //   },
    // );
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    _ttsHandler = TTSHandler();
    await _ttsHandler.initTextToSpeech(); //set up listeners for elevenlabs tts.
    // Set voice settings from current persona after initialization
    final personaTheme = ref.read(personaThemeProvider);
    if (personaTheme != null) {
      debugPrint(
          'Setting voice from persona inside the TTSHandler:${personaTheme} + ${personaTheme.voiceId}');
      _ttsHandler.setVoiceFromPersona(personaTheme);
    } else {
      debugPrint('Warning: PersonaTheme is null during TTS initialization.');
    }
  }

  @override
  void didChangeDependencies() {
    //first time the screen is built
    super.didChangeDependencies();

    if (!_hasAddedInitialText && widget.initialText != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleInitialText(
            widget.initialText!); //add the initial text to the chat provider
      });
      _hasAddedInitialText =
          true; //set the flag to true so that the initial text is not added again
    }
  }

  // Future<void> _handleInitialText(String message) async {
  //   final chats = ref.read(ChatProvider.notifier);

  //   // Add user's message
  //   chats.add(MessageModel(
  //     id: DateTime.now().toString(),
  //     message: message,
  //     isUser: true,
  //   ));

  //   setReplyingState(true);
  //   chats.add(
  //       const MessageModel(id: 'bot', message: 'Replying...', isUser: false));

  //   await _openAIService.streamChatGPTAPI(
  //     message: message,
  //     onDelta: (partialText) {
  //       debugPrint('Received delta: $partialText'); // Debug log
  //       // Accumulate streamed delta
  //       _processor.handleChunk(partialText);
  //       debugPrint('Current text: ${_processor.currentText}'); // Debug log

  //       // Update UI with current buffer
  //       chats.updateLastAssistantMessage(_processor.currentText);

  //       // If sentence is ready, speak it
  //       if (_processor.hasSentenceReady()) {
  //         final sentence = _processor.popSentence();
  //         debugPrint('Speaking sentence: $sentence'); // Debug log
  //         _ttsHandler.playTextToSpeech(sentence);
  //       }
  //     },
  //     onDone: () {
  //       debugPrint(
  //           'Stream done, final text: ${_processor.currentText}'); // Debug log
  //       // Flush any remaining sentence
  //       final finalSentence = _processor.flushRemaining();
  //       if (finalSentence.isNotEmpty) {
  //         debugPrint('Speaking final sentence: $finalSentence'); // Debug log
  //         _ttsHandler.playTextToSpeech(finalSentence);
  //       }

  //       // Replace "Replying..." with final full message
  //       eliminateReplyStatus();
  //       chats.add(MessageModel(
  //         id: DateTime.now().toString(),
  //         message: _processor.currentText,
  //         isUser: false,
  //       ));
  //       setReplyingState(false);
  //     },
  //   );
  // }

  Future<void> _handleInitialText(String message) async {
    final chats = ref.read(ChatProvider.notifier);

    // Add user message
    chats.add(MessageModel(
      id: DateTime.now().toString(),
      message: message,
      isUser: true,
    ));
    setReplyingState(true);
    chats.add(
        const MessageModel(id: 'bot', message: 'Replying..', isUser: false));
    // Get AI response
    final aiResponse = await _openAIService.ChatGPTAPI(message);
    // Ensure TTS is initialized and voice settings are set before speaking
    if (!_ttsHandler.isInitialized) {
      await _initializeTTS();
    }
    // Re-set voice settings before speaking
    final personaTheme = ref.read(personaThemeProvider);
    if (personaTheme != null) {
      debugPrint('Setting voice before speaking: ${personaTheme.voiceId}');
      _ttsHandler.setVoiceFromPersona(personaTheme);
    }

    eliminateReplyStatus();

    chats.add(MessageModel(
      // Add AI message
      id: DateTime.now().toString(),
      message: aiResponse,
      isUser: false,
    ));
    Future.microtask(() => _ttsHandler.playTextToSpeech(aiResponse));
    setReplyingState(false);
  }

  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(ChatProvider).reversed.toList();

    return Scaffold(
      appBar: ChatAppBar(),
      body: GradientBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: chats.length,
                itemBuilder: (context, index) => ChatBubble(
                  message: chats[index].message,
                  isUser: chats[index].isUser,
                  //persona: widget.persona ?? 'Nova',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
              child: TextAndVoice(persona: widget.persona ?? 'Nova'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
