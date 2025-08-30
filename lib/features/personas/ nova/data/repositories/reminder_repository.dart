import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/base_reminder_repository.dart';
import '../models/reminder_dto.dart';

class ReminderRepository extends BaseReminderRepository {
  final FirebaseFirestore _firestore;

  ReminderRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  //  Helper method to get the user's reminders collection
  //   CollectionReference<Map<String, dynamic>> _userReminders(String userId) {
  //   return _firestore.collection('users').doc(userId).collection('reminders');
  // }

  CollectionReference<Map<String, dynamic>> _userReminders(
      String userId, String personaId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('personas')
        .doc(personaId)
        .collection('reminders');
  }

  @override
  Future<void> addReminder(
      String userId, String personaId, Reminder reminder) async {
    try {
      //final dto = ReminderDto.fromDomain(reminder);
      final reminderId = Uuid().v4();
      final dto = ReminderDto.fromDomain(reminder.copyWith(id: reminderId));
      await _userReminders(userId, personaId)
          .doc(reminderId)
          .set(dto.toDocument());
      // Operation was successful!  Now, potentially update local state.
    } on FirebaseException catch (e, stack) {
      print('🔥 Firebase error adding reminder: ${e.message}');
      print(stack);
      // Ideally: log to Crashlytics or rethrow a custom AppError.
      rethrow;
    } catch (e, stack) {
      print('❌ Unexpected error adding reminder: $e');
      print(stack);
      rethrow;
    }
  }
  // await _userReminders(userId,personaId).doc(reminder.id).set(ReminderDto.fromDomain(reminder).toDocument());

  @override
  Future<void> updateReminder(
    String userId, String personaId, Reminder reminder) async {
    if (reminder.id == null) {
      throw ArgumentError('Reminder ID cannot be null for updates.');
    }
    final dto = ReminderDto.fromDomain(reminder);
    try {
      await _userReminders(userId, personaId)
          .doc(reminder.id)
          .set(dto.toDocument(), SetOptions(merge: true));
      // The `SetOptions(merge: true)` option tells Firestore to only update
      // the fields that are present in the `dto.toDocument()` map, leaving
      // other fields unchanged.
    } on FirebaseException catch (e, stack) {
      print('🔥 Firebase error updating reminder: ${e.message}');
      print(stack);
      // Ideally: log to Crashlytics or rethrow a custom AppError.
      rethrow;
    } catch (e, stack) {
      print('❌ Unexpected error updating reminder: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteReminder(
      String userId, String personaId, String reminderId) async {
     try {
      // Argument check for null or empty reminderId
      if (reminderId.isEmpty) {
        throw ArgumentError('Reminder ID cannot be null or empty for deletion.');
      }

      await _userReminders(userId, personaId).doc(reminderId).delete();
    } on FirebaseException catch (e, stack) {
      print('🔥 Firebase error deleting reminder: ${e.message}');
      print(stack);
      rethrow;
    } catch (e, stack) {
      print('❌ Unexpected error deleting reminder: $e');
      print(stack);
      rethrow;
    }
  }

  @override
  Stream<List<Reminder>> watchReminders(String userId, String personaId) {

    return _userReminders(userId, personaId)
      .snapshots()
      .handleError((e, stack) {
        print('🔥 Error in watchReminders: $e');
      })
      .map((snap) => snap.docs
          .map((doc) => ReminderDto.fromSnapshot(doc).toDomain())
          .toList());
    //throw UnimplementedError();
    // try{
    //     return _userReminders(userId, personaId).snapshots().map((snap) => snap.docs
    //     .map((doc) => ReminderDto.fromSnapshot(doc).toDomain())
    //     .toList());
    // }catch(e){
    //   print('Error watching reminders: $e');
    //   rethrow;
    // }
  }
}
