// lib/features/personas/nova/data/sources/nova_firestore_source.dart
class NovaFirestoreSource {
  Future<String?> getLatestGrocery() async {
    // Query groceries collection, orderBy createdAt desc, limit 1
    return "Milk"; // stub for now
  }

  Future<String?> getLatestTodo() async {
    return "Book vaccine"; // stub
  }

  Future<String?> getLatestReminder() async {
    return "Doctor said take meds"; // stub
  }
  
  Future<String?> getLatestVoiceMemo() async {
    return "Pick Ali by 4 pm"; // stub
  }

  Future<String?> getLatestAppointment() async {
    return "Booked a doctor's appointment"; // stub
  }
}
