import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/todo.dart';

class TodoDto extends Equatable {
  final String? id;
  final String task;
  final String? description;
  final bool isCompleted;
  final String? priority;      // "low" | "medium" | "high" | null
  final DateTime? deadline;    // optional deadline
  final DateTime createdAt;
  final DateTime updatedAt;

  const TodoDto({
    this.id,
    required this.task,
    this.description,
    this.isCompleted = false,
    this.priority,
    this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });

  // 🔹 From Firestore Snapshot → DTO
  factory TodoDto.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return TodoDto(
      id: snap.id,
      task: data['task'] ?? '',
      description: data['description'],
      isCompleted: data['isCompleted'] ?? false,
      priority: data['priority'],
      deadline: data['deadline'] != null
          ? (data['deadline'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  // 🔹 DTO → Firestore Document
  Map<String, Object?> toDocument() {
    return {
      'task': task,
      'description': description,
      'isCompleted': isCompleted,
      'priority': priority,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  // 🔹 DTO → Domain Entity
  Todo toDomain() {
    return Todo(
      id: id,
      task: task,
      description: description,
      isCompleted: isCompleted,
      priority: priority,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // 🔹 Domain Entity → DTO
  factory TodoDto.fromDomain(Todo todo) {
    return TodoDto(
      id: todo.id,
      task: todo.task,
      description: todo.description,
      isCompleted: todo.isCompleted,
      priority: todo.priority,
      deadline: todo.deadline,
      createdAt: todo.createdAt,
      updatedAt: todo.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, task, description, isCompleted, priority, deadline, createdAt, updatedAt];
}
