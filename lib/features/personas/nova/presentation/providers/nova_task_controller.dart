import 'package:flutter/material.dart';
import 'package:voice_input/shared/models/task_item.dart';
import '../../data/datasources/nova_datasources.dart';

class NovaTaskRepository {
  final NovaStaticSource staticSource;
  final NovaFirestoreSource firestoreSource;

  NovaTaskRepository({
    required this.staticSource,
    required this.firestoreSource,
  });

  Future<List<TaskItem>> getAllTasks() async {
    final staticItems = staticSource.getStaticTasks();
    final latestGrocery = await firestoreSource.getLatestGrocery();
    final latestTodo = await firestoreSource.getLatestTodo();
    final latestReminder = await firestoreSource.getLatestReminder();
    final latestVoiceMemo = await firestoreSource.getLatestVoiceMemo();
    final latestAppointment = await firestoreSource.getLatestAppointment();

    return [
      TaskItem(
          type: TaskType.staticTask,
          title: "Grocery List",
          icon: Icons.shopping_cart,
          detail: latestGrocery ?? "No items yet"),
      TaskItem(
          type: TaskType.staticTask,
          title: "To-Do List",
          icon: Icons.check_circle,
          detail: latestTodo ?? "No tasks yet"),
      TaskItem(
          type: TaskType.staticTask,
          title: "Reminders",
          icon: Icons.notifications,
          detail: latestReminder ?? "No reminders yet"),
      TaskItem(
          type: TaskType.staticTask,
          title: "Voice Memos",
          icon: Icons.mic,
          detail: latestVoiceMemo ?? "No recordings yet"),
      TaskItem(
          type: TaskType.staticTask,
          title: "Appointments",
          icon: Icons.calendar_today,
          detail: latestAppointment ?? "No appointments yet"),
    ];
  }
}
