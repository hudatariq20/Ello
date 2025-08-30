import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:porcupine_flutter/porcupine_error.dart';

class PorcupineService {
  PorcupineManager? _porcupineManager;
  bool _isListening = false;
  final Function(int) onWakeWordDetected;
  final String accessKey =
      "OKYvIo4pzOgP++iKwf3iR2zYzaYJ5ixZyk0C3r4qaxHhcPZKC4laQQ==";

  PorcupineService({required this.onWakeWordDetected});

  Future<void> init() async {
    try {
      _porcupineManager = await PorcupineManager.fromKeywordPaths(
        accessKey,
        ["assets/resources/keyword_files/ios/Hey-Nova_en_ios_v3_0_0.ppn"],
        onWakeWordDetected,
        errorCallback: (error) {
          print("Error in Porcupine: $error");
        },
      );
    } on PorcupineException catch (error) {
      print("Failed to initialize Porcupine: $error");
      rethrow;
    }
  }

  Future<void> startListening() async {
    if (_porcupineManager == null) {
      throw Exception("Porcupine not initialized. Call init() first.");
    }

    if (!_isListening) {
      await _porcupineManager!.start();
      _isListening = true;
    }
  }

  Future<void> stopListening() async {
    if (_isListening && _porcupineManager != null) {
      await _porcupineManager!.stop();
      _isListening = false;
    }
  }

  Future<void> dispose() async {
    await stopListening();
    _porcupineManager?.delete();
  }
}
