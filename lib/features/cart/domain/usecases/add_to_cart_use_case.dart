import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/cart/domain/entities/cart.dart';
import 'package:ecom/features/cart/domain/errors/cart_exceptions.dart';
import 'package:ecom/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecom/features/products/domain/entities/product.dart';

/// Use case for adding a product to the cart.
///
/// Handles business logic for:
/// - Validating product availability
/// - Managing quantity limits
/// - Logging cart operations
class AddToCartUseCase {
  final CartRepository _repository;

  const AddToCartUseCase({required CartRepository repository})
    : _repository = repository;

  /// Add a product to the cart.
  ///
  /// Parameters:
  /// - [product]: The product to add
  /// - [quantity]: Quantity to add (default: 1)
  ///
  /// Returns the updated cart.
  /// Throws [CartException] if operation fails.
  Future<Cart> execute(Product product, {int quantity = 1}) async {
    AppLogger.info(
      'Adding product to cart: ${product.name}, quantity: $quantity',
    );

    try {
      if (!product.isInStock) {
        throw const ProductOutOfStockException();
      }

      if (quantity <= 0) {
        throw const InvalidQuantityException('Quantity must be greater than 0');
      }

      final cart = await _repository.addProduct(product, quantity: quantity);

      AppLogger.info(
        'Successfully added product to cart. New item count: ${cart.itemCount}',
      );
      return cart;
    } catch (e) {
      AppLogger.error('Failed to add product to cart', e);
      rethrow;
    }
  }

  /// Allows calling the use case as a function.
  Future<Cart> call(Product product, {int quantity = 1}) =>
      execute(product, quantity: quantity);
}
