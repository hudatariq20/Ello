import 'package:flutter/foundation.dart';

class ChatStreamProcessor {
  // Callback function triggered for partial message updates (e.g., streaming UI)
  final void Function(String) onPartialUpdate;

  // Callback function triggered when a complete sentence is detected (e.g., for TTS)
  final void Function(String) onSentenceReady;

  // Buffer for streaming text chunks before they're complete sentences
  final StringBuffer _buffer = StringBuffer();

  // Queue to store detected complete sentences
  final List<String> _sentences = [];

  ChatStreamProcessor({
    required this.onPartialUpdate,
    required this.onSentenceReady,
  });

  /// Handles an incoming text chunk (delta from the stream).
  /// - Updates the partial text view
  /// - Detects and extracts complete sentences
  /// - Triggers callbacks for each complete sentence
  void handleChunk(String chunk) {
    debugPrint('Processing chunk: $chunk'); // Debug log
    _buffer.write(chunk); // Append new chunk to buffer

    // Trigger the partial update callback with current full text
    final currentText = this.currentText;
    debugPrint('Current text after chunk: $currentText'); // Debug log
    onPartialUpdate(currentText);

    final text = _buffer.toString();

    // Match all completed sentences using punctuation (., !, ?)
    final matches = RegExp(r'[^.!?]*[.!?]').allMatches(text);

    if (matches.isNotEmpty) {
      for (final match in matches) {
        final sentence = match.group(0)!.trim();
        if (sentence.isNotEmpty) {
          debugPrint('Found complete sentence: $sentence'); // Debug log
          _sentences.add(sentence); // Add sentence to queue
          onSentenceReady(sentence); // Trigger sentence-ready callback
        }
      }

      // Remove the processed complete sentences from the buffer,
      // leaving any partial sentence behind
      final lastIndex = matches.last.end;
      final remaining = text.substring(lastIndex);
      debugPrint('Remaining text: $remaining'); // Debug log
      _buffer
        ..clear()
        ..write(remaining);
    }
  }

  /// Checks if there is a completed sentence ready for use (e.g., for TTS)
  bool hasSentenceReady() {
    return currentText.trim().endsWith('.') ||
        currentText.trim().endsWith('!') ||
        currentText.trim().endsWith('?') ||
        currentText.split(' ').length >= 12; // heuristically treat as complete
  }

  /// Pops and returns the first sentence in the queue (FIFO)
  String popSentence() {
    if (_sentences.isEmpty) return '';
    return _sentences.removeAt(0);
  }

  /// Returns the current full text including:
  /// - All queued complete sentences
  /// - Any remaining partial content in the buffer
  String get currentText {
    final combined = StringBuffer();
    for (final sentence in _sentences) {
      combined.write('$sentence ');
    }
    combined.write(_buffer.toString());
    final result = combined.toString().trim();
    debugPrint('Combined text: $result'); // Debug log
    return result;
  }

  /// Flushes and returns any leftover partial text in the buffer
  /// (useful at the end of a stream)
  String flushRemaining() {
    final remaining = _buffer.toString().trim();
    debugPrint('Flushing remaining: $remaining'); // Debug log
    _buffer.clear();
    return remaining;
  }

  /// Clears both the sentence queue and buffer
  /// (use this between messages or conversations)
  void clear() {
    _buffer.clear();
    _sentences.clear();
  }
}
