import 'dart:convert';
import 'package:ecom/core/storage/secure_storage.dart';
import 'package:ecom/features/cart/data/models/cart_model.dart';
import 'package:ecom/features/cart/domain/entities/cart.dart';
import 'package:ecom/features/cart/domain/errors/cart_exceptions.dart';
import 'package:ecom/core/logging/app_logger.dart';

/// Interface for cart storage operations.
abstract class CartStorage {
  Future<void> saveCart(Cart cart);
  Future<Cart?> loadCart();
  Future<void> clearCart();
}

/// Implementation of cart storage using secure storage.
///
/// Persists cart data to device storage using encrypted storage.
class CartStorageImpl implements CartStorage {
  final SecureStorage _storage;
  static const String _cartKey = 'shopping_cart';

  CartStorageImpl({required SecureStorage storage}) : _storage = storage;

  @override
  Future<void> saveCart(Cart cart) async {
    try {
      AppLogger.info('Saving cart with ${cart.itemCount} items');

      final cartModel = CartModel.fromEntity(cart);
      final jsonString = json.encode(cartModel.toJson());

      await _storage.write(_cartKey, jsonString);

      AppLogger.info('Successfully saved cart');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save cart', e, stackTrace);
      throw CartPersistenceException('Failed to save cart: $e');
    }
  }

  @override
  Future<Cart?> loadCart() async {
    try {
      AppLogger.info('Loading cart from storage');

      final jsonString = await _storage.read(_cartKey);
      if (jsonString == null || jsonString.isEmpty) {
        AppLogger.info('No cart found in storage');
        return null;
      }

      final jsonData = json.decode(jsonString) as Map<String, dynamic>;
      final cartModel = CartModel.fromJson(jsonData);
      final cart = cartModel.toEntity();

      AppLogger.info('Successfully loaded cart with ${cart.itemCount} items');
      return cart;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load cart', e, stackTrace);
      // Return empty cart instead of throwing to prevent app crashes
      AppLogger.warning('Returning empty cart due to load failure');
      return const Cart();
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      AppLogger.info('Clearing cart from storage');

      await _storage.delete(_cartKey);

      AppLogger.info('Successfully cleared cart from storage');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to clear cart from storage', e, stackTrace);
      throw CartPersistenceException('Failed to clear cart: $e');
    }
  }
}
