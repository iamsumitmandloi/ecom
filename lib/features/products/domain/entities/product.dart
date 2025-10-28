import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

/// Product entity representing an e-commerce product.
///
/// Contains all product information including:
/// - Basic info (name, description, price)
/// - Stock management
/// - User engagement (ratings, favorites)
/// - Categorization
///
/// Business logic is included as getters for computed properties.
@freezed
class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
    required int stock,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    @Default(false) bool isFavorite,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  /// Check if product is currently in stock
  bool get isInStock => stock > 0;

  /// Check if product stock is running low (5 or fewer items)
  bool get isLowStock => stock > 0 && stock <= 5;

  /// Check if product is out of stock
  bool get isOutOfStock => stock == 0;

  /// Format price as currency string
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Get stock status message
  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Only $stock left';
    return 'In Stock';
  }

  /// Check if product has ratings
  bool get hasRatings => reviewCount > 0;

  /// Get rating display text
  String get ratingText => hasRatings ? '$rating ($reviewCount)' : 'No ratings';
}
