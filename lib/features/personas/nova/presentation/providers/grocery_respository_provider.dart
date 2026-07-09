import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories/grocery_repository.dart';
import '../../data/repositories/stub_grocery_repository.dart';
import '../../domain/entities/grocery.dart';



final groceryRepositoryProvider = Provider<GroceryRepository>((ref) {
  //return GroceryRepository(firestore: ref.read(firestoreProvider));
  return StubGroceryRepository(firestore: FirebaseFirestore.instance);
});

final activeGroceriesProvider = StreamProvider<List<GroceryItem>>((ref) {
  final repo = ref.watch(groceryRepositoryProvider);
  return repo.watchActiveGroceries("demoUser");
});

final completedGroceriesProvider = StreamProvider<List<GroceryItem>>((ref) {
  final repo = ref.watch(groceryRepositoryProvider);
  return repo.watchCompletedGroceries("demoUser");
});