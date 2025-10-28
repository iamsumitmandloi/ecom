import 'package:ecom/features/products/domain/entities/category.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

/// Data model for Category entity.
///
/// Used for JSON serialization/deserialization with Firestore REST API.
/// Maps between Firestore documents and domain entities.
@freezed
class CategoryModel with _$CategoryModel {
  const CategoryModel._();

  const factory CategoryModel({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
    @Default(0) int productCount,
  }) = _CategoryModel;

  /// Create from Firestore document
  factory CategoryModel.fromFirestore(Map<String, dynamic> firestoreDoc) {
    final fields = firestoreDoc['fields'] as Map<String, dynamic>;

    return CategoryModel(
      id: firestoreDoc['name']?.toString().split('/').last ?? '',
      name: fields['name']?['stringValue'] as String? ?? '',
      description: fields['description']?['stringValue'] as String?,
      imageUrl: fields['imageUrl']?['stringValue'] as String?,
      productCount:
          int.tryParse(
            fields['productCount']?['integerValue']?.toString() ?? '0',
          ) ??
          0,
    );
  }

  /// Convert to Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'fields': {
        'name': {'stringValue': name},
        if (description != null) 'description': {'stringValue': description},
        if (imageUrl != null) 'imageUrl': {'stringValue': imageUrl},
        'productCount': {'integerValue': productCount.toString()},
      },
    };
  }

  /// Convert to domain entity
  Category toEntity() {
    return Category(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
      productCount: productCount,
    );
  }

  /// Create from domain entity
  factory CategoryModel.fromEntity(Category entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      productCount: entity.productCount,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);
}
