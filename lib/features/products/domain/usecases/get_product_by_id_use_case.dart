import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:ecom/features/products/domain/errors/product_exceptions.dart';
import 'package:ecom/features/products/domain/repositories/products_repository.dart';

/// Use case for fetching a single product by ID.
///
/// Encapsulates business logic for:
/// - Product ID validation
/// - Logging product detail views
/// - Error handling for not found products
///
/// Example:
/// ```dart
/// final product = await getProductByIdUseCase.execute('product-123');
/// // Or using call syntax
/// final product = await getProductByIdUseCase('product-123');
/// ```
class GetProductByIdUseCase {
  final ProductsRepository _repository;

  const GetProductByIdUseCase({required ProductsRepository repository})
    : _repository = repository;

  /// Execute the use case to fetch a single product.
  ///
  /// Parameters:
  /// - [productId]: Unique identifier of the product
  ///
  /// Returns the product if found.
  /// Throws [InvalidProductIdException] if productId is empty.
  /// Throws [ProductNotFoundException] if product doesn't exist.
  Future<Product> execute(String productId) async {
    // Validate product ID
    final trimmedId = productId.trim();
    if (trimmedId.isEmpty) {
      throw const InvalidProductIdException();
    }

    AppLogger.info('Fetching product detail: $trimmedId');

    try {
      final product = await _repository.getProductById(trimmedId);
      AppLogger.info('Product detail fetched: ${product.name}');
      return product;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch product: $trimmedId', e, stackTrace);
      rethrow;
    }
  }

  /// Allows calling the use case as a function.
  Future<Product> call(String productId) => execute(productId);
}
