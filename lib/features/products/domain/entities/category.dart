import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// Category entity for product categorization.
///
/// Represents a product category with:
/// - Unique identifier
/// - Display name
/// - Optional description and image
/// - Product count for display
@freezed
class Category with _$Category {
  const Category._();

  const factory Category({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
    @Default(0) int productCount,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  /// Check if category has products
  bool get hasProducts => productCount > 0;

  /// Display name with proper capitalization
  String get displayName {
    // Split by spaces, capitalize each word, then join
    return name
        .split(' ')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}
