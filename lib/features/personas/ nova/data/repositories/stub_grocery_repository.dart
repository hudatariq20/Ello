import 'dart:async';

import 'package:voice_input/features/personas/%20nova/data/repositories/grocery_repository.dart';
import 'package:voice_input/features/personas/%20nova/domain/entities/grocery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class StubGroceryRepository extends GroceryRepository {
  final List<GroceryItem> _items =  [
    GroceryItem(id: '1', name: 'Milk', quantity: 2, unit: QuantityUnit.litre),
    GroceryItem(id: '2', name: 'Eggs', quantity: 1, unit: QuantityUnit.dozen),
    GroceryItem(
        id: '3',
        name: 'Bread',
        quantity: 1,
        unit: QuantityUnit.packet,
        purchased: true),
    GroceryItem(id: '4', name: 'Apples', quantity: 6, unit: QuantityUnit.pcs),
  ];

  final _controller = StreamController<List<GroceryItem>>.broadcast();

  StubGroceryRepository({required FirebaseFirestore firestore}) : super(firestore: firestore) {
    _emit();
  }

  void _emit() {
      print("🔄 Emitting ${_items.length} items...");
    _controller.add(List.unmodifiable(_items));
  }

  @override
  Future<void> addGrocery(String userId, GroceryItem item) async {
     Future.microtask(_emit);
    _items.add(
        item.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString()));
    _emit();
  }

  @override
  Future<void> clearCompletedGroceries(String userId) async {
     Future.microtask(_emit);
    _items.removeWhere((e) => e.purchased);
    _emit();
  }

  @override
  Future<void> deleteGrocery(String userId, String itemId) async {
    _items.removeWhere((e) => e.id == itemId);
    _emit();
  }

  @override
  Future<void> reAddToActive(String userId, GroceryItem item) async{
     Future.microtask(_emit);
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index == -1) return;
    _items[index] = item.copyWith(purchased: false);
    _emit();
  }
  
  @override
  Future<void> addtoCompleted(String userId, GroceryItem item) async{
     Future.microtask(_emit);
    final index = _items.indexWhere((e) => e.id == item.id);
    if (index == -1) return;
    _items[index] = item.copyWith(purchased: true);
    _emit();
  }


  @override
  Future<void> updateGrocery(String userId, GroceryItem item) async{
     Future.microtask(_emit);
   final index = _items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      _items[index] = item;
      _emit();
    }
  }

  @override
  Stream<List<GroceryItem>> watchActiveGroceries(String userId) {
     Future.microtask(_emit);
    return _controller.stream
        .map((list) => list.where((item) => !item.purchased).toList());
  }


  @override
  Stream<List<GroceryItem>> watchCompletedGroceries(String userId) {
     Future.microtask(_emit);
    return _controller.stream
        .map((list) => list.where((item) => item.purchased).toList());
  }
}
