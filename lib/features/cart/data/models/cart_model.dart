import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ecom/features/cart/domain/entities/cart.dart';
import 'package:ecom/features/cart/data/models/cart_item_model.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

/// Data model for cart serialization.
///
/// Used for JSON serialization/deserialization and storage.
@freezed
class CartModel with _$CartModel {
  const CartModel._();

  const factory CartModel({@Default([]) List<CartItemModel> items}) =
      _CartModel;

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  /// Convert to domain entity
  Cart toEntity() => Cart(items: items.map((item) => item.toEntity()).toList());

  /// Create from domain entity
  factory CartModel.fromEntity(Cart entity) => CartModel(
    items: entity.items.map((item) => CartItemModel.fromEntity(item)).toList(),
  );
}
