import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ecom/features/products/domain/entities/product.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

/// Cart item entity representing a product in the shopping cart.
///
/// Contains:
/// - Product information
/// - Quantity selected
/// - Business logic for calculations
@freezed
class CartItem with _$CartItem {
  const CartItem._();

  const factory CartItem({required Product product, required int quantity}) =
      _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);

  /// Get the total price for this cart item (product price × quantity)
  double get totalPrice => product.price * quantity;

  /// Get formatted total price as currency string
  String get formattedTotalPrice => '\$${totalPrice.toStringAsFixed(2)}';

  /// Check if this item is in stock
  bool get isInStock => product.isInStock;

  /// Check if quantity exceeds available stock
  bool get exceedsStock => quantity > product.stock;

  /// Get maximum allowed quantity (limited by stock)
  int get maxQuantity => product.stock;

  /// Check if quantity can be increased
  bool get canIncreaseQuantity => quantity < product.stock;

  /// Check if quantity can be decreased
  bool get canDecreaseQuantity => quantity > 1;

  /// Get stock status message
  String get stockStatus {
    if (!isInStock) return 'Out of Stock';
    if (exceedsStock) return 'Exceeds Available Stock';
    if (product.isLowStock) return 'Only ${product.stock} left';
    return 'In Stock';
  }

  /// Create a copy with updated quantity
  CartItem withQuantity(int newQuantity) {
    if (newQuantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }
    if (newQuantity > product.stock) {
      throw ArgumentError('Quantity cannot exceed available stock');
    }
    return copyWith(quantity: newQuantity);
  }

  /// Increment quantity by 1
  CartItem increment() {
    if (!canIncreaseQuantity) {
      throw StateError('Cannot increase quantity beyond available stock');
    }
    return copyWith(quantity: quantity + 1);
  }

  /// Decrement quantity by 1
  CartItem decrement() {
    if (!canDecreaseQuantity) {
      throw StateError('Cannot decrease quantity below 1');
    }
    return copyWith(quantity: quantity - 1);
  }
}
