import 'package:equatable/equatable.dart';


enum QuantityUnit {
  pcs,      // pieces
  dozen,    // e.g. dozen eggs
  bunch,    // e.g. bunch of coriander
  packet,   // chips, snacks
  bottle,   // drinks, sauces
  can,      // canned food
  g,        // grams
  kg,       // kilograms
  ml,       // milliliters
  litre,    // liters
}

extension QuantityUnitX on QuantityUnit {
  String get label {
    switch (this) {
      case QuantityUnit.pcs:
        return "pcs";
      case QuantityUnit.dozen:
        return "dozen";
      case QuantityUnit.bunch:
        return "bunch";
      case QuantityUnit.packet:
        return "packet";
      case QuantityUnit.bottle:
        return "bottle";
      case QuantityUnit.can:
        return "can";
      case QuantityUnit.g:
        return "g";
      case QuantityUnit.kg:
        return "kg";
      case QuantityUnit.ml:
        return "ml";
      case QuantityUnit.litre:
        return "litre";
    }
  }

  static QuantityUnit fromString(String value) {
    return QuantityUnit.values.firstWhere(
      (e) => e.label == value,
      orElse: () => QuantityUnit.pcs,
    );
  }
}

class GroceryItem extends Equatable {
  final String? id;
  final String name;
  final double quantity;
  final QuantityUnit unit;
  final bool purchased;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  const GroceryItem({
    this.id,
    required this.name,
    this.quantity = 1,
    this.unit = QuantityUnit.pcs,
    this.purchased = false,
    this.createdAt, 
    this.updatedAt,
    this.completedAt,
  });

  GroceryItem copyWith({
    String? id,
    String? name,
    double? quantity,
    QuantityUnit? unit,
    bool? purchased,
  }) => GroceryItem(id: id ?? this.id, name: name ?? this.name, quantity: quantity ?? this.quantity, unit: unit ?? this.unit, purchased: purchased ?? this.purchased, createdAt: createdAt ?? this.createdAt, updatedAt: updatedAt ?? this.updatedAt, completedAt: completedAt ?? this.completedAt);

  @override
  List<Object?> get props => [id, name, quantity, unit, purchased, createdAt, updatedAt, completedAt];
}
