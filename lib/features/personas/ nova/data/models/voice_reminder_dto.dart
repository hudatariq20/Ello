import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:voice_input/features/personas/%20nova/domain/entities/nova_entities.dart';

class VoiceReminderDto extends Equatable {
  final String? id;
  final String audioUrl;
  final DateTime remindAt;

  const VoiceReminderDto({
    this.id,
    required this.audioUrl,
    required this.remindAt,
  });

  //  From Firestore Snapshot → DTO
  factory VoiceReminderDto.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return VoiceReminderDto(
      id: snap.id,
      audioUrl: data['audioUrl'] ?? '',
      remindAt: data['remindAt'] ?? DateTime.now(),
    );
  }

  //  DTO → Firestore Document
  Map<String, Object?> toDocument() {
    return {
      'audioUrl': audioUrl,
      'remindAt': remindAt,
    };
  }

  //  DTO → Domain Entity
  VoiceReminder toDomain() {
    return VoiceReminder(
      id: id,
      audioUrl: audioUrl,
      remindAt: remindAt,
    );
  }

  //  Domain Entity → DTO
  factory VoiceReminderDto.fromDomain(VoiceReminder reminder) {
    return VoiceReminderDto(
      id: reminder.id,
      audioUrl: reminder.audioUrl,
      remindAt: reminder.remindAt,
    );
  }

  @override
  List<Object?> get props => [id, audioUrl, remindAt];
}
