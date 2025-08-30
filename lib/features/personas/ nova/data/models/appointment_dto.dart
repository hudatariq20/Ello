import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:voice_input/features/personas/%20nova/domain/entities/nova_entities.dart';

class AppointmentDto extends Equatable {
  final String? id;
  final String title;
  final DateTime scheduledAt;
  final String location;

  const AppointmentDto({
    this.id,
    required this.title,
    required this.scheduledAt,
    this.location = '',
  });

  //  From Firestore Snapshot → DTO
  factory AppointmentDto.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return AppointmentDto(
      id: snap.id,
      title: data['title'] ?? '',
      scheduledAt: data['scheduledAt'] ?? DateTime.now(),
      location: data['location'] ?? '',
    );
  }

  //  DTO → Firestore Document
  Map<String, Object?> toDocument() {
    return {
      'title': title,
      'scheduledAt': scheduledAt,
      'location': location,
    };
  }

  //  DTO → Domain Entity
  Appointment toDomain() {
    return Appointment(
      id: id,
      title: title,
      scheduledAt: scheduledAt,
      location: location,
    );
  }

  //  Domain Entity → DTO
  factory AppointmentDto.fromDomain(Appointment appointment) {
    return AppointmentDto(
      id: appointment.id,
      title: appointment.title,
      scheduledAt: appointment.scheduledAt,
      location: appointment.location,
    );
  }

  List<Object?> get props => [id, title, scheduledAt, location];
}
