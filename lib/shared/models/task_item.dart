import 'package:flutter/material.dart';

enum TaskType { staticTask, dynamicTask }

class TaskItem {
  final TaskType type;
  final String title;
  final String? detail;
  final IconData? icon;

  TaskItem({
    required this.type,
    required this.title,
    this.detail,
    this.icon,
  });
}
