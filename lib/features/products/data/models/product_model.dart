import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_model.freezed.dart';
part 'product_model.g.dart';

/// Data model for Product entity.
///
/// Used for JSON serialization/deserialization with Firestore REST API.
/// Maps between Firestore documents and domain entities.
@freezed
class ProductModel with _$ProductModel {
  const ProductModel._();

  const factory ProductModel({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
    @Default(0) int stock,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(false) bool isFavorite,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ProductModel;

  /// Create from Firestore document
  factory ProductModel.fromFirestore(Map<String, dynamic> firestoreDoc) {
    final fields = firestoreDoc['fields'] as Map<String, dynamic>;

    return ProductModel(
      id: firestoreDoc['name']?.toString().split('/').last ?? '',
      name: fields['name']?['stringValue'] as String? ?? '',
      description: fields['description']?['stringValue'] as String? ?? '',
      price:
          double.tryParse(fields['price']?['doubleValue']?.toString() ?? '0') ??
          0.0,
      imageUrl: fields['imageUrl']?['stringValue'] as String? ?? '',
      category: fields['category']?['stringValue'] as String? ?? '',
      stock:
          int.tryParse(fields['stock']?['integerValue']?.toString() ?? '0') ??
          0,
      rating:
          double.tryParse(
            fields['rating']?['doubleValue']?.toString() ?? '0',
          ) ??
          0.0,
      reviewCount:
          int.tryParse(
            fields['reviewCount']?['integerValue']?.toString() ?? '0',
          ) ??
          0,
      isFavorite: fields['isFavorite']?['booleanValue'] as bool? ?? false,
      createdAt:
          DateTime.tryParse(
            fields['createdAt']?['timestampValue'] as String? ?? '',
          ) ??
          DateTime.now(),
      updatedAt: fields['updatedAt']?['timestampValue'] != null
          ? DateTime.tryParse(fields['updatedAt']!['timestampValue'] as String)
          : null,
    );
  }

  /// Convert to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'fields': {
        'name': {'stringValue': name},
        'description': {'stringValue': description},
        'price': {'doubleValue': price},
        'imageUrl': {'stringValue': imageUrl},
        'category': {'stringValue': category},
        'stock': {'integerValue': stock.toString()},
        'rating': {'doubleValue': rating},
        'reviewCount': {'integerValue': reviewCount.toString()},
        'isFavorite': {'booleanValue': isFavorite},
        'createdAt': {'timestampValue': createdAt.toIso8601String()},
        if (updatedAt != null)
          'updatedAt': {'timestampValue': updatedAt!.toIso8601String()},
      },
    };
  }

  /// Convert to domain entity
  Product toEntity() {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      category: category,
      stock: stock,
      rating: rating,
      reviewCount: reviewCount,
      isFavorite: isFavorite,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create from domain entity
  factory ProductModel.fromEntity(Product entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price: entity.price,
      imageUrl: entity.imageUrl,
      category: entity.category,
      stock: entity.stock,
      rating: entity.rating,
      reviewCount: entity.reviewCount,
      isFavorite: entity.isFavorite,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
}
