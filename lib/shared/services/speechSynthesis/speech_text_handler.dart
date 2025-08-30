import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechHandler {
  stt.SpeechToText speech = stt.SpeechToText();
  bool islisteningEnabled = false;

  Future<void> initSpeech() async {
    islisteningEnabled = await speech.initialize();
    if (!islisteningEnabled) {
      throw Exception('Speech recognition not available');
    }
  }

  Future<String> startListening() async {
    if (!islisteningEnabled) {
      await initSpeech();
    }

    final completer = Completer<String>();
    speech.listen(
      listenFor: Duration(seconds: 10), // Optional timeout
      pauseFor: Duration(seconds: 2),
      onResult: (result) {
        if (result.finalResult) {
          completer.complete(result.recognizedWords);
        }
      },
    );
    return completer.future;
  }

  Future<void> stopListening() async {
    await speech.stop();
  }
}
