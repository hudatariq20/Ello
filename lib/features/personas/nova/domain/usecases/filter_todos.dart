import '../entities/nova_entities.dart';

/// Filters a list of [Todo]s to return only those that are overdue.
///
/// A task is considered overdue if its deadline is before the start of the current day
/// and the task is not yet completed.
///
/// [todos]: The list of [Todo]s to filter.
/// Returns: A new list containing only the overdue [Todo]s.
List<Todo> getOverdueTasks(List<Todo> todos) {
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  return todos
      .where((t) =>
          t.deadline != null &&
          t.deadline!.isBefore(todayStart) &&
          !t.isCompleted)
      .toList();
}

/// Filters a list of [Todo]s to return only those scheduled for today.
///
/// A task is considered for today if its deadline falls within the current day
/// (from the start of today to the end of today) and the task is not yet completed.
///
/// [todos]: The list of [Todo]s to filter.
/// Returns: A new list containing only the [Todo]s scheduled for today.
List<Todo> getTodayTasks(List<Todo> todos) {
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);
  final todayEnd = todayStart.add(const Duration(days: 1));
  return todos
      .where((t) =>
          t.deadline != null &&
          t.deadline!
              .isAfter(todayStart.subtract(const Duration(seconds: 1))) &&
          t.deadline!.isBefore(todayEnd) &&
          !t.isCompleted)
      .toList();
}
