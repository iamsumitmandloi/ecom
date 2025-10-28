import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/cart/domain/entities/cart.dart';
import 'package:ecom/features/cart/domain/repositories/cart_repository.dart';

/// Use case for clearing the entire cart.
///
/// Handles business logic for:
/// - Confirming cart clear operation
/// - Logging clear operations
class ClearCartUseCase {
  final CartRepository _repository;

  const ClearCartUseCase({required CartRepository repository})
    : _repository = repository;

  /// Clear all items from the cart.
  ///
  /// Returns an empty cart.
  /// Throws [CartException] if operation fails.
  Future<Cart> execute() async {
    AppLogger.info('Clearing cart');

    try {
      final cart = await _repository.clearCart();

      AppLogger.info('Successfully cleared cart');
      return cart;
    } catch (e) {
      AppLogger.error('Failed to clear cart', e);
      rethrow;
    }
  }

  /// Allows calling the use case as a function.
  Future<Cart> call() => execute();
}
