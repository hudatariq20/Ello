import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/grocery.dart';

class GroceryItemDto extends Equatable {
  final String? id;
  final String name;
  final double quantity; // Changed from int → double
  final String unit; // New field
  final bool purchased;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;

  const GroceryItemDto({
    this.id,
    required this.name,
    this.quantity = 1,
    this.unit = "pcs", // default unit
    this.purchased = false,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
  });

  // From Firestore Snapshot → DTO
  factory GroceryItemDto.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    return GroceryItemDto(
      id: snap.id,
      name: data['name'] ?? '',
      quantity: (data['quantity'] ?? 1).toDouble(),
      unit: data['unit'] ?? 'pcs',
      purchased: data['purchased'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      completedAt: (data['completedAt'] as Timestamp?)?.toDate(),
    );
  }

  // DTO → Firestore Document
  Map<String, Object?> toDocument() {
    return {
      'name': name,
      'quantity': quantity,
      'unit': unit,
      'purchased': purchased,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'completedAt': completedAt != null ? Timestamp.fromDate(completedAt!) : null,
    };
  }

  // DTO → Domain Entity
  GroceryItem toDomain() {
    return GroceryItem(
      id: id,
      name: name,
      quantity: quantity,
      unit: QuantityUnitX.fromString(unit), // use enum mapping
      purchased: purchased,
      createdAt: createdAt,
      updatedAt: updatedAt,
      completedAt: completedAt,
    );
  }

  // Domain Entity → DTO
  factory GroceryItemDto.fromDomain(GroceryItem item) {
    return GroceryItemDto(
      id: item.id,
      name: item.name,
      quantity: item.quantity,
      unit: item.unit.label,
      purchased: item.purchased,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      completedAt: item.completedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, quantity, unit, purchased, createdAt, updatedAt, completedAt];
}
