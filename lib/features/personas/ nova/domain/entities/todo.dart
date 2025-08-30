import 'package:equatable/equatable.dart';

class Todo extends Equatable {
  final String? id;
  final String task;
  final String? description;   // optional notes
  final bool isCompleted;      // ✅ simple for now
  final String? priority;      // "low" | "medium" | "high" | null
  final DateTime? deadline;    // optional deadline
  final DateTime createdAt;    // when task created
  final DateTime updatedAt;    // when task last updated

  const Todo({
    this.id,
    required this.task,
    this.description,
    this.isCompleted = false,
    this.priority,
    this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });

  Todo copyWith({
    String? id,
    String? task,
    String? description,
    bool? isCompleted,
    String? priority,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      task: task ?? this.task,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, task, description, isCompleted, priority, deadline, createdAt, updatedAt];
}
