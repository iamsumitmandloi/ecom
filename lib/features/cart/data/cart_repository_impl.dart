import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/cart/data/cart_storage.dart';
import 'package:ecom/features/cart/domain/entities/cart.dart';
import 'package:ecom/features/cart/domain/errors/cart_exceptions.dart';
import 'package:ecom/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecom/features/products/domain/entities/product.dart';

/// Implementation of CartRepository using local storage.
///
/// Handles cart persistence and business logic validation.
class CartRepositoryImpl implements CartRepository {
  final CartStorage _storage;
  Cart? _cachedCart;

  CartRepositoryImpl({required CartStorage storage}) : _storage = storage;

  @override
  Future<Cart> getCart() async {
    try {
      if (_cachedCart != null) {
        AppLogger.debug('Returning cached cart');
        return _cachedCart!;
      }

      AppLogger.info('Loading cart from storage');
      final cart = await _storage.loadCart() ?? const Cart();
      _cachedCart = cart;

      AppLogger.info('Cart loaded with ${cart.itemCount} items');
      return cart;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to get cart', e, stackTrace);
      throw CartPersistenceException('Failed to load cart: $e');
    }
  }

  @override
  Future<void> saveCart(Cart cart) async {
    try {
      AppLogger.info('Saving cart with ${cart.itemCount} items');

      await _storage.saveCart(cart);
      _cachedCart = cart;

      AppLogger.info('Cart saved successfully');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save cart', e, stackTrace);
      throw CartPersistenceException('Failed to save cart: $e');
    }
  }

  @override
  Future<Cart> addProduct(Product product, {int quantity = 1}) async {
    try {
      AppLogger.info(
        'Adding product to cart: ${product.name}, quantity: $quantity',
      );

      if (!product.isInStock) {
        throw const ProductOutOfStockException();
      }

      if (quantity <= 0) {
        throw const InvalidQuantityException('Quantity must be greater than 0');
      }

      final cart = await getCart();
      final updatedCart = cart.addProduct(product, quantity: quantity);

      await saveCart(updatedCart);

      AppLogger.info('Product added to cart successfully');
      return updatedCart;
    } catch (e) {
      AppLogger.error('Failed to add product to cart', e);
      rethrow;
    }
  }

  @override
  Future<Cart> removeProduct(String productId) async {
    try {
      AppLogger.info('Removing product from cart: $productId');

      final cart = await getCart();
      final updatedCart = cart.removeProduct(productId);

      await saveCart(updatedCart);

      AppLogger.info('Product removed from cart successfully');
      return updatedCart;
    } catch (e) {
      AppLogger.error('Failed to remove product from cart', e);
      rethrow;
    }
  }

  @override
  Future<Cart> updateProductQuantity(String productId, int quantity) async {
    try {
      AppLogger.info(
        'Updating product quantity: $productId, quantity: $quantity',
      );

      if (quantity < 0) {
        throw const InvalidQuantityException('Quantity cannot be negative');
      }

      final cart = await getCart();
      final updatedCart = cart.updateProductQuantity(productId, quantity);

      await saveCart(updatedCart);

      AppLogger.info('Product quantity updated successfully');
      return updatedCart;
    } catch (e) {
      AppLogger.error('Failed to update product quantity', e);
      rethrow;
    }
  }

  @override
  Future<Cart> clearCart() async {
    try {
      AppLogger.info('Clearing cart');

      const emptyCart = Cart();
      await saveCart(emptyCart);

      AppLogger.info('Cart cleared successfully');
      return emptyCart;
    } catch (e) {
      AppLogger.error('Failed to clear cart', e);
      rethrow;
    }
  }

  @override
  Future<int> getItemCount() async {
    try {
      final cart = await getCart();
      return cart.itemCount;
    } catch (e) {
      AppLogger.error('Failed to get item count', e);
      return 0;
    }
  }

  @override
  Future<bool> containsProduct(String productId) async {
    try {
      final cart = await getCart();
      return cart.containsProduct(productId);
    } catch (e) {
      AppLogger.error('Failed to check if product is in cart', e);
      return false;
    }
  }

  @override
  Future<int> getProductQuantity(String productId) async {
    try {
      final cart = await getCart();
      return cart.getProductQuantity(productId);
    } catch (e) {
      AppLogger.error('Failed to get product quantity', e);
      return 0;
    }
  }
}
