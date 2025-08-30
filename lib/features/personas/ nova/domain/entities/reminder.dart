import 'package:equatable/equatable.dart';

class Reminder extends Equatable {
  final String? id;
  final String message;
  final DateTime remindAt;
  final bool isCompleted;

  const Reminder({
    this.id,
    required this.message,
    required this.remindAt,
    this.isCompleted = false,
  });

  Reminder copyWith({
    String? id,
    String? message,
    DateTime? remindAt,
    bool? isCompleted,
  }) {
    return Reminder(
      id: id ?? this.id,
      message: message ?? this.message,
      remindAt: remindAt ?? this.remindAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [id, message, remindAt, isCompleted];
}
