import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ecom/features/cart/domain/entities/cart_item.dart';
import 'package:ecom/features/products/domain/entities/product.dart';

part 'cart.freezed.dart';
part 'cart.g.dart';

/// Shopping cart entity containing cart items and business logic.
///
/// Provides:
/// - Item management (add, remove, update)
/// - Price calculations (subtotal, tax, total)
/// - Cart state queries
@freezed
class Cart with _$Cart {
  const Cart._();

  const factory Cart({@Default([]) List<CartItem> items}) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);

  /// Get total number of items in cart
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get number of unique products in cart
  int get uniqueItemCount => items.length;

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart has items
  bool get isNotEmpty => items.isNotEmpty;

  /// Get subtotal (sum of all item prices)
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Get formatted subtotal as currency string
  String get formattedSubtotal => '\$${subtotal.toStringAsFixed(2)}';

  /// Get tax amount (8.5% of subtotal)
  double get taxAmount => subtotal * 0.085;

  /// Get formatted tax amount as currency string
  String get formattedTaxAmount => '\$${taxAmount.toStringAsFixed(2)}';

  /// Get total amount (subtotal + tax)
  double get total => subtotal + taxAmount;

  /// Get formatted total as currency string
  String get formattedTotal => '\$${total.toStringAsFixed(2)}';

  /// Get shipping cost (free for orders over $50, otherwise $5.99)
  double get shippingCost => subtotal >= 50.0 ? 0.0 : 5.99;

  /// Get formatted shipping cost as currency string
  String get formattedShippingCost {
    if (shippingCost == 0.0) return 'FREE';
    return '\$${shippingCost.toStringAsFixed(2)}';
  }

  /// Get final total including shipping
  double get finalTotal => total + shippingCost;

  /// Get formatted final total as currency string
  String get formattedFinalTotal => '\$${finalTotal.toStringAsFixed(2)}';

  /// Check if cart qualifies for free shipping
  bool get qualifiesForFreeShipping => subtotal >= 50.0;

  /// Get amount needed for free shipping
  double get amountNeededForFreeShipping {
    if (qualifiesForFreeShipping) return 0.0;
    return 50.0 - subtotal;
  }

  /// Get formatted amount needed for free shipping
  String get formattedAmountNeededForFreeShipping {
    if (qualifiesForFreeShipping) return 'You qualify for free shipping!';
    return '\$${amountNeededForFreeShipping.toStringAsFixed(2)} more for free shipping';
  }

  /// Add a product to cart or increase quantity if already exists
  Cart addProduct(Product product, {int quantity = 1}) {
    if (quantity <= 0) {
      throw ArgumentError('Quantity must be greater than 0');
    }
    if (!product.isInStock) {
      throw StateError('Product is out of stock');
    }

    final existingItemIndex = items.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingItemIndex != -1) {
      // Product already in cart, increase quantity
      final existingItem = items[existingItemIndex];
      final newQuantity = existingItem.quantity + quantity;

      if (newQuantity > product.stock) {
        throw StateError('Cannot add more items than available in stock');
      }

      final updatedItems = List<CartItem>.from(items);
      updatedItems[existingItemIndex] = existingItem.copyWith(
        quantity: newQuantity,
      );

      return copyWith(items: updatedItems);
    } else {
      // New product, add to cart
      final newItem = CartItem(product: product, quantity: quantity);
      return copyWith(items: [...items, newItem]);
    }
  }

  /// Remove a product from cart completely
  Cart removeProduct(String productId) {
    final updatedItems = items
        .where((item) => item.product.id != productId)
        .toList();
    return copyWith(items: updatedItems);
  }

  /// Update quantity of a specific product
  Cart updateProductQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      return removeProduct(productId);
    }

    final itemIndex = items.indexWhere((item) => item.product.id == productId);
    if (itemIndex == -1) {
      throw ArgumentError('Product not found in cart');
    }

    final item = items[itemIndex];
    if (newQuantity > item.product.stock) {
      throw StateError('Cannot set quantity higher than available stock');
    }

    final updatedItems = List<CartItem>.from(items);
    updatedItems[itemIndex] = item.copyWith(quantity: newQuantity);

    return copyWith(items: updatedItems);
  }

  /// Clear all items from cart
  Cart clear() => const Cart();

  /// Get cart item by product ID
  CartItem? getItemByProductId(String productId) {
    try {
      return items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Check if a product is in the cart
  bool containsProduct(String productId) {
    return items.any((item) => item.product.id == productId);
  }

  /// Get quantity of a specific product in cart
  int getProductQuantity(String productId) {
    final item = getItemByProductId(productId);
    return item?.quantity ?? 0;
  }

  /// Validate cart (check for out of stock items, etc.)
  List<String> validate() {
    final errors = <String>[];

    for (final item in items) {
      if (!item.product.isInStock) {
        errors.add('${item.product.name} is out of stock');
      } else if (item.exceedsStock) {
        errors.add('${item.product.name} quantity exceeds available stock');
      }
    }

    return errors;
  }

  /// Check if cart has any validation errors
  bool get hasValidationErrors => validate().isNotEmpty;

  /// Get validation error messages
  List<String> get validationErrors => validate();
}
