import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/reminder.dart';

class ReminderDto extends Equatable {
  final String? id;
  final String message;
  final Timestamp remindAt; // Firestore uses Timestamp
  final bool isCompleted;

  const ReminderDto({
    this.id,
    this.message = '',
    required this.remindAt,
    this.isCompleted = false,
  });

  //  From Firestore Snapshot → DTO
  factory ReminderDto.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return ReminderDto(
      id: snap.id,
      message: data['message'] ?? '',
      remindAt: data['remindAt'] as Timestamp? ?? Timestamp.now(),
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  //  DTO → Firestore Document
  Map<String, Object?> toDocument() {
    return {
      'message': message,
      'remindAt': remindAt,
      'isCompleted': isCompleted,
    };
  }

  //  DTO → Domain Entity
  Reminder toDomain() {
    return Reminder(
      id: id,
      message: message,
      remindAt: remindAt.toDate(), // convert Timestamp → DateTime
      isCompleted: isCompleted,
    );
  }

  //  Domain Entity → DTO
  factory ReminderDto.fromDomain(Reminder reminder) {
    return ReminderDto(
      id: reminder.id,
      message: reminder.message,
      remindAt: Timestamp.fromDate(reminder.remindAt),
      isCompleted: reminder.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, message, remindAt, isCompleted];
}
