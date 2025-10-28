import 'package:ecom/features/cart/domain/entities/cart.dart';
import 'package:ecom/features/products/domain/entities/product.dart';

/// Abstract repository interface for cart operations.
///
/// Defines contracts for:
/// - Cart persistence (save/load)
/// - Cart operations (add, remove, update)
/// - Cart state management
abstract class CartRepository {
  /// Get the current cart
  Future<Cart> getCart();

  /// Save the cart to persistent storage
  Future<void> saveCart(Cart cart);

  /// Add a product to the cart
  Future<Cart> addProduct(Product product, {int quantity = 1});

  /// Remove a product from the cart
  Future<Cart> removeProduct(String productId);

  /// Update the quantity of a product in the cart
  Future<Cart> updateProductQuantity(String productId, int quantity);

  /// Clear all items from the cart
  Future<Cart> clearCart();

  /// Get the current cart item count
  Future<int> getItemCount();

  /// Check if a product is in the cart
  Future<bool> containsProduct(String productId);

  /// Get the quantity of a specific product in the cart
  Future<int> getProductQuantity(String productId);
}
