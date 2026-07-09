import '../entities/reminder.dart';

abstract class BaseReminderRepository {
  Future<void> addReminder(String userId, String personaId, Reminder reminder);
  Future<void> updateReminder(
      String userId, String personaId, Reminder reminder);
  Future<void> deleteReminder(
      String userId, String personaId, String reminderId);
  Stream<List<Reminder>> watchReminders(String userId, String personaId);
}
