import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_input/shared/models/message_model.dart';

class ChatNotifier extends StateNotifier<List<MessageModel>> {
  ChatNotifier() : super([]);
  void add(MessageModel messageModel) {
    state = [...state, messageModel];
  }

  void removeStatus() {
    state = state..removeWhere((chat) => chat.id == 'bot');
  }

  void addUserMessage(String message) {
    state = [
      ...state,
      MessageModel(id: 'user', message: message, isUser: true)
    ];
  }

  /// Adds a new assistant message with optional initial text (usually empty at start of streaming)
  void addAssistantMessage(String message) {
    state = [
      ...state,
      MessageModel(id: 'bot', message: message, isUser: false)
    ];
  }

  /// Updates the last assistant message (used during streaming)
  void updateLastAssistantMessage(String newText) {
    if (state.isNotEmpty && !state.last.isUser) {
      state = [
        ...state.sublist(0, state.length - 1), // All except last
        state.last.copyWith(message: newText), // Replace last with updated
      ];
    }
  }
}

final ChatProvider = StateNotifierProvider<ChatNotifier, List<MessageModel>>(
    (ref) => ChatNotifier());
