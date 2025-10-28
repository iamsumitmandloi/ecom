import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/cart/domain/entities/cart.dart';
import 'package:ecom/features/cart/domain/errors/cart_exceptions.dart';
import 'package:ecom/features/cart/domain/repositories/cart_repository.dart';

/// Use case for updating product quantity in the cart.
///
/// Handles business logic for:
/// - Validating quantity limits
/// - Managing stock constraints
/// - Logging quantity updates
class UpdateCartQuantityUseCase {
  final CartRepository _repository;

  const UpdateCartQuantityUseCase({required CartRepository repository})
    : _repository = repository;

  /// Update the quantity of a product in the cart.
  ///
  /// Parameters:
  /// - [productId]: ID of the product to update
  /// - [quantity]: New quantity (0 removes the item)
  ///
  /// Returns the updated cart.
  /// Throws [CartException] if operation fails.
  Future<Cart> execute(String productId, int quantity) async {
    AppLogger.info('Updating cart quantity: $productId, quantity: $quantity');

    try {
      if (quantity < 0) {
        throw const InvalidQuantityException('Quantity cannot be negative');
      }

      final cart = await _repository.updateProductQuantity(productId, quantity);

      AppLogger.info(
        'Successfully updated cart quantity. New item count: ${cart.itemCount}',
      );
      return cart;
    } catch (e) {
      AppLogger.error('Failed to update cart quantity', e);
      rethrow;
    }
  }

  /// Allows calling the use case as a function.
  Future<Cart> call(String productId, int quantity) =>
      execute(productId, quantity);
}
