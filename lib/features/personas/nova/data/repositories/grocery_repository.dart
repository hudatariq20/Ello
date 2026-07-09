import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/nova_entities.dart';
import '../../domain/repositories/base_grocery_repository.dart';
import '../models/nova_models.dart';

class GroceryRepository extends BaseGroceryRepository {
  final FirebaseFirestore _firestore;

  GroceryRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> _groceriesCollection(
          String userId) =>
      _firestore
          .collection('users')
          .doc(userId)
          .collection('personas')
          .doc('nova')
          .collection('groceries');

  @override
  Future<void> addGrocery(String userId, GroceryItem item) {
    return _groceriesCollection(userId).add({
      ...GroceryItemDto.fromDomain(item).toDocument(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'completedAt': null,
    });
  }

  @override
  Future<void> clearCompletedGroceries(String userId) async {
    final snapshot = await _groceriesCollection(userId)
        .where('purchased', isEqualTo: true)
        .get();

    await Future.wait(snapshot.docs.map((doc) => doc.reference.delete()));
  }

  @override
  Future<void> deleteGrocery(String userId, String itemId) async {
    await _groceriesCollection(userId).doc(itemId).delete();
  }

  @override
  Future<void> reAddToActive(String userId, GroceryItem item) async {
    if (item.id == null) return;
    await _groceriesCollection(userId).doc(item.id).update({
      'purchased': false,
      'updatedAt': FieldValue.serverTimestamp(),
      'completedAt': null,
    });
  }

  @override
  Future<void> updateGrocery(String userId, GroceryItem item) async {
    if (item.id == null) return;
    await _groceriesCollection(userId).doc(item.id).update({
      ...GroceryItemDto.fromDomain(item).toDocument(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<GroceryItem>> watchActiveGroceries(String userId) {
     return _groceriesCollection(userId)
        .where('purchased', isEqualTo: false)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => GroceryItemDto.fromSnapshot(doc).toDomain())
            .toList());
  }

  @override
  Stream<List<GroceryItem>> watchCompletedGroceries(String userId) {
    return _groceriesCollection(userId)
        .where('purchased', isEqualTo: true)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs
            .map((doc) => GroceryItemDto.fromSnapshot(doc).toDomain())
            .toList());
  }
  
  @override
  Future<void> addtoCompleted(String userId, GroceryItem item) {
    // TODO: implement addtoCompleted
    throw UnimplementedError();
  }
}
