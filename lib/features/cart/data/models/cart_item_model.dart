import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ecom/features/cart/domain/entities/cart_item.dart';
import 'package:ecom/features/products/data/models/product_model.dart';

part 'cart_item_model.freezed.dart';
part 'cart_item_model.g.dart';

/// Data model for cart item serialization.
///
/// Used for JSON serialization/deserialization and storage.
@freezed
class CartItemModel with _$CartItemModel {
  const CartItemModel._();

  const factory CartItemModel({
    required ProductModel product,
    required int quantity,
  }) = _CartItemModel;

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  /// Convert to domain entity
  CartItem toEntity() =>
      CartItem(product: product.toEntity(), quantity: quantity);

  /// Create from domain entity
  factory CartItemModel.fromEntity(CartItem entity) => CartItemModel(
    product: ProductModel.fromEntity(entity.product),
    quantity: entity.quantity,
  );
}
