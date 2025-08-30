// lib/features/personas/nova/data/sources/nova_static_source.dart
import 'package:flutter/material.dart';
import 'package:voice_input/shared/models/task_item.dart';

class NovaStaticSource {
  List<TaskItem> getStaticTasks() {
    return [
      TaskItem(
          type: TaskType.staticTask,
          title: "Grocery List",
          icon: Icons.shopping_cart),
      TaskItem(
          type: TaskType.staticTask,
          title: "To-Do List",
          icon: Icons.check_circle),
      TaskItem(
          type: TaskType.staticTask,
          title: "Reminders",
          icon: Icons.notifications),
      TaskItem(
          type: TaskType.staticTask, title: "Voice Memos", icon: Icons.mic),
      TaskItem(
          type: TaskType.staticTask,
          title: "Appointments",
          icon: Icons.calendar_today),
    ];
  }
}
