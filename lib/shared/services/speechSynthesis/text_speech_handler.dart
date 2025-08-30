import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart'; // Needed for compute()
import 'package:voice_input/shared/models/personaTheme_model.dart';
import 'package:voice_input/shared/services/ElevenLabsTTS/audio_stream_source.dart';

/// Handles text-to-speech functionality using both ElevenLabs API and FlutterTTS
/// as a fallback. Manages audio playback state and provides methods for speech synthesis.
class TTSHandler {
  // Text-to-speech engine for fallback
  final FlutterTts flutterTts = FlutterTts();
  // Audio player for ElevenLabs audio playback
  final AudioPlayer player = AudioPlayer();

  // State management flags
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isLoading = false;
  Completer<void>? _initCompleter; //completer for the initialization

  /// Gets whether the TTS handler is initialized
  bool get isInitialized => _isInitialized;

  // Voice settings from current persona
  String _currentVoiceId = ''; // Default voice ID (Rachel)
  double _currentStability = 0.15;
  double _currentSimilarity = 0.75;

  // Stream subscriptions for audio player state and errors
  StreamSubscription<PlayerState>? _playerStateSub;
  StreamSubscription<PlaybackEvent>? _playbackErrorSub;

  /// Sets the voice settings from a PersonaTheme
  void setVoiceFromPersona(PersonaTheme persona) {
    debugPrint(
        'Setting voice from persona inside the TTSHandler:${persona} + ${persona.voiceId}');
    _currentVoiceId = persona.voiceId;
    _currentStability = persona.voiceStability;
    _currentSimilarity = persona.voiceSimilarity;
    debugPrint('Voice settings updated from persona: $_currentVoiceId');
  }

  /// Gets the current voice ID
  String get currentVoiceId => _currentVoiceId;

  /// Converts Uint8List to List<int> in a separate isolate to prevent UI blocking
  /// This is necessary because audio data processing can be heavy
  Future<List<int>> _extractBytesInIsolate(Uint8List data) async {
    return compute((Uint8List input) => input.toList(), data);
  }

  // Future<void> initTextToSpeech() async {
  //   if (_isInitialized) return;

  //   await _initTTS();
  //   _setupListeners();
  //   _isInitialized = true;
  // }

  /// Initializes the TTS system if not already initialized
  /// Sets up both FlutterTTS and audio player listeners
  Future<void> initTextToSpeech() async {
    if (_isInitialized)
      return _initCompleter?.future ??
          Future.value(); //if already initialized, return the future

    _initCompleter = Completer(); //create a new completer
    try {
      await _initTTS(); //initialize the TTS
      _setupListeners(); //set up the listeners
      _isInitialized = true;
      _initCompleter!.complete(); //complete the completer
    } catch (e) {
      _initCompleter!.completeError(e); //complete the completer with the error
      rethrow;
    }
  }

  /// Initializes FlutterTTS with default settings
  Future<void> _initTTS() async {
    try {
      await flutterTts.setLanguage("en-US");
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      debugPrint('FlutterTTS initialized');
    } catch (e) {
      debugPrint('TTS initialization error: $e');
    }
  }

  /// Sets up listeners for audio player state changes and errors
  void _setupListeners() {
    // Listen for player state changes (e.g., completed, error)
    _playerStateSub = player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _isPlaying = false;
        _isLoading = false;
        debugPrint('Playback completed');
      }
    });

    // Listen for playback errors
    _playbackErrorSub = player.playbackEventStream.listen(
      (_) {},
      onError: (Object e, StackTrace _) {
        debugPrint('Playback error: $e');
        _isPlaying = false;
        _isLoading = false;
      },
    );
  }

  /// Converts text to speech using ElevenLabs API
  /// Falls back to FlutterTTS if ElevenLabs fails
  Future<void> playTextToSpeech(String text) async {
    //check if the TTSHandler is initialized
    if (!_isInitialized) {
      debugPrint('TTSHandler not initialized. Call initTextToSpeech() first.');
      return;
    }
    // Stop any ongoing playback before starting new one
    if (_isLoading || _isPlaying) {
      await stop();
    }

    _isLoading = true;

    try {
      // Make API request to ElevenLabs with current voice settings
      final response = await http.post(
        Uri.parse(
            'https://api.elevenlabs.io/v1/text-to-speech/$_currentVoiceId'),
        headers: {
          'accept': 'audio/mpeg',
          'xi-api-key': dotenv.env['EL_API_KEY']!,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "text": text,
          "model_id": "eleven_monolingual_v1",
          "voice_settings": {
            "stability": _currentStability,
            "similarity_boost": _currentSimilarity
          }
        }),
      );

      // Process successful response
      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        debugPrint('Audio byte length (raw): ${response.bodyBytes.length}');

        // Convert bytes in isolate to prevent UI blocking
        final audioBytes = await _extractBytesInIsolate(response.bodyBytes);
        debugPrint('Audio byte length (isolated): ${audioBytes.length}');

        // Stop any existing playback and set new audio source
        await player.stop();
        await player.setAudioSource(MyCustomSource(audioBytes));
        _isPlaying = true;
        await player.play();
      } else {
        throw Exception('Invalid ElevenLabs response: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('TTSHandler ElevenLabs error: $e');
      // Fallback to FlutterTTS if ElevenLabs fails
      try {
        await flutterTts.speak(text);
      } catch (fallbackError) {
        debugPrint('Fallback TTS error: $fallbackError');
      }
    } finally {
      _isLoading = false;
    }
  }

  /// Stops all audio playback
  Future<void> stop() async {
    try {
      await player.stop();
      await flutterTts.stop();
    } catch (e) {
      debugPrint('Error during stop: $e');
    } finally {
      _isPlaying = false;
      _isLoading = false;
    }
  }

  /// Alias for stop() for clearer API
  Future<void> cancel() async {
    await stop();
  }

  /// Clean up resources when the handler is no longer needed
  void dispose() {
    _playerStateSub?.cancel();
    _playbackErrorSub?.cancel();
    player.dispose();
  }
}
