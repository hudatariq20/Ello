import '../../domain/entities/nova_entities.dart';

final mockTodos = [
  // Overdue
  Todo(
    id: "1",
    task: "Do a weekly review",
    description: "Do a weekly review of my tasks and goals",
    isCompleted: false,
    deadline: DateTime.now().subtract(const Duration(days: 2)), // overdue
    priority: "high",
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    updatedAt: DateTime.now(),
  ),
  Todo(
    id: "2",
    task: "Send client presentation",
    isCompleted: false,
    deadline: DateTime.now().subtract(const Duration(days: 1)), // overdue
    priority: "medium",
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    updatedAt: DateTime.now(),
  ),

  // Today
  Todo(
    id: "3",
    task: "Buy groceries",
    description: "Buy groceries for the week",
    isCompleted: false,
    deadline: DateTime.now(), // today
    priority: "medium",
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    updatedAt: DateTime.now(),
  ),
  Todo(
    id: "4",
    task: "Team standup meeting",
    isCompleted: false,
    deadline: DateTime.now(), // today
    priority: "high",
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    updatedAt: DateTime.now(),
  ),
];
