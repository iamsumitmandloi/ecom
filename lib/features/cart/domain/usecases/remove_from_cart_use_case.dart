import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/cart/domain/entities/cart.dart';
import 'package:ecom/features/cart/domain/repositories/cart_repository.dart';

/// Use case for removing a product from the cart.
///
/// Handles business logic for:
/// - Validating product exists in cart
/// - Logging removal operations
class RemoveFromCartUseCase {
  final CartRepository _repository;

  const RemoveFromCartUseCase({required CartRepository repository})
    : _repository = repository;

  /// Remove a product from the cart.
  ///
  /// Parameters:
  /// - [productId]: ID of the product to remove
  ///
  /// Returns the updated cart.
  /// Throws [CartException] if operation fails.
  Future<Cart> execute(String productId) async {
    AppLogger.info('Removing product from cart: $productId');

    try {
      final cart = await _repository.removeProduct(productId);

      AppLogger.info(
        'Successfully removed product from cart. New item count: ${cart.itemCount}',
      );
      return cart;
    } catch (e) {
      AppLogger.error('Failed to remove product from cart', e);
      rethrow;
    }
  }

  /// Allows calling the use case as a function.
  Future<Cart> call(String productId) => execute(productId);
}
