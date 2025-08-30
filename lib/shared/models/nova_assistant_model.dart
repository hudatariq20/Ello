class NovaAssistantModel {
  final bool isWakeWordListening;
  final bool isSpeechListening;
  final String transcribedText;

  NovaAssistantModel({
    required this.isWakeWordListening,
    required this.isSpeechListening,
    required this.transcribedText,
  });

  factory NovaAssistantModel.initial() => NovaAssistantModel(
        isWakeWordListening: false,
        isSpeechListening: false,
        transcribedText: '',
      );

  NovaAssistantModel copyWith({
    bool? isWakeWordListening,
    bool? isSpeechListening,
    String? transcribedText,
  }) {
    return NovaAssistantModel(
      isWakeWordListening: isWakeWordListening ?? this.isWakeWordListening,
      isSpeechListening: isSpeechListening ?? this.isSpeechListening,
      transcribedText: transcribedText ?? this.transcribedText,
    );
  }
}
