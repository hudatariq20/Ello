import 'package:equatable/equatable.dart';

class VoiceReminder extends Equatable {
  final String? id;
  final String audioUrl; // could be Firebase Storage URL
  final DateTime remindAt;

  const VoiceReminder({
    this.id,
    required this.audioUrl,
    required this.remindAt,
  });

  @override
  List<Object?> get props => [id, audioUrl, remindAt];
}
