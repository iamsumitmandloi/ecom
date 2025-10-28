/// Cart-related domain exceptions.
///
/// These exceptions represent business logic errors that can occur
/// during cart operations.
sealed class CartException implements Exception {
  final String message;
  const CartException(this.message);
}

/// Thrown when trying to add an out-of-stock product to cart
class ProductOutOfStockException extends CartException {
  const ProductOutOfStockException([super.message = 'Product is out of stock']);
}

/// Thrown when trying to add more items than available in stock
class InsufficientStockException extends CartException {
  const InsufficientStockException([
    super.message = 'Not enough items in stock',
  ]);
}

/// Thrown when trying to update quantity to an invalid value
class InvalidQuantityException extends CartException {
  const InvalidQuantityException([super.message = 'Invalid quantity']);
}

/// Thrown when trying to operate on a product not in cart
class ProductNotInCartException extends CartException {
  const ProductNotInCartException([
    super.message = 'Product not found in cart',
  ]);
}

/// Thrown when cart validation fails
class CartValidationException extends CartException {
  const CartValidationException([super.message = 'Cart validation failed']);
}

/// Thrown when cart persistence fails
class CartPersistenceException extends CartException {
  const CartPersistenceException([super.message = 'Failed to save cart']);
}

/// Generic cart error
class UnknownCartException extends CartException {
  const UnknownCartException([
    super.message = 'An unexpected cart error occurred',
  ]);
}
