
import '../entities/nova_entities.dart' show GroceryItem;

abstract class BaseGroceryRepository {
  /// Stream of all active groceries (purchased == false)
  Stream<List<GroceryItem>> watchActiveGroceries(String userId);

  /// Stream of all completed groceries (purchased == true)
  Stream<List<GroceryItem>> watchCompletedGroceries(String userId);

  /// Add a new grocery item
  Future<void> addGrocery(String userId, GroceryItem item);

  /// Update an existing grocery item (e.g., toggle purchased, edit name/qty)
  Future<void> updateGrocery(String userId, GroceryItem item);

  /// Add a grocery item to the completed list
  Future<void> addtoCompleted(String userId, GroceryItem item);

  /// Delete a grocery item
  Future<void> deleteGrocery(String userId, String itemId);

  /// Clear all completed groceries
  Future<void> clearCompletedGroceries(String userId);

  /// Re-add a completed grocery back to active
  Future<void> reAddToActive(String userId, GroceryItem item);
}
