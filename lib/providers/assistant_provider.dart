// logic/assistant_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/shared/models/nova_assistant_model.dart';

class AssistantNotifier extends StateNotifier<NovaAssistantModel> {
  AssistantNotifier() : super(NovaAssistantModel.initial());

  void setWakeWordListening(bool listening) {
    state = state.copyWith(isWakeWordListening: listening);
  }

  void setSpeechListening(bool listening) {
    state = state.copyWith(isSpeechListening: listening);
  }

  void setTranscribedText(String text) {
    state = state.copyWith(transcribedText: text);
  }
}

// providers/assistant_provider.dart
final assistantProvider =
    StateNotifierProvider<AssistantNotifier, NovaAssistantModel>(
  (ref) => AssistantNotifier(),
);
