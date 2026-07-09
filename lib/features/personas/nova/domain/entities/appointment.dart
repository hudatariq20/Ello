import 'package:equatable/equatable.dart';

class Appointment extends Equatable {
  final String? id;
  final String title;
  final DateTime scheduledAt;
  final String location;

  const Appointment({
    this.id,
    required this.title,
    required this.scheduledAt,
    this.location = '',
  });

  @override
  List<Object?> get props => [id, title, scheduledAt, location];
}
