/// Base exception for product-related errors
sealed class ProductException implements Exception {
  final String message;
  const ProductException(this.message);

  @override
  String toString() => message;
}

/// Thrown when a product is not found
class ProductNotFoundException extends ProductException {
  const ProductNotFoundException([super.message = 'Product not found']);
}

/// Thrown when product ID is invalid (empty or whitespace)
class InvalidProductIdException extends ProductException {
  const InvalidProductIdException([
    super.message = 'Product ID cannot be empty',
  ]);
}

/// Thrown when product data is invalid
class InvalidProductDataException extends ProductException {
  const InvalidProductDataException([super.message = 'Invalid product data']);
}

/// Thrown when fetching products fails
class ProductFetchException extends ProductException {
  const ProductFetchException([super.message = 'Failed to fetch products']);
}

/// Thrown when search query is invalid
class InvalidSearchQueryException extends ProductException {
  const InvalidSearchQueryException([
    super.message = 'Search query is too short',
  ]);
}

/// Thrown when category is not found
class CategoryNotFoundException extends ProductException {
  const CategoryNotFoundException([super.message = 'Category not found']);
}
