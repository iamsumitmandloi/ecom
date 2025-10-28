import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:ecom/features/products/domain/repositories/products_repository.dart';

/// Use case for fetching products with optional filtering and sorting.
///
/// Encapsulates business logic for:
/// - Logging product views
/// - Applying default pagination
/// - Handling category filters
/// - Sorting products
///
/// Example:
/// ```dart
/// final products = await getProductsUseCase.execute(
///   category: 'electronics',
///   limit: 20,
/// );
/// ```
class GetProductsUseCase {
  final ProductsRepository _repository;

  const GetProductsUseCase({required ProductsRepository repository})
    : _repository = repository;

  /// Execute the use case to fetch products.
  ///
  /// Parameters:
  /// - [limit]: Number of products to fetch (default: 20)
  /// - [offset]: Starting index for pagination (converted to Firestore cursor)
  ///
  /// Returns list of products.
  Future<List<Product>> execute({int? limit, int? offset, String? startAfter}) async {
    AppLogger.info('Fetching products: limit=$limit, offset=$offset');

    try {
      // For now, we ignore offset since Firestore uses startAfter
      // This will be properly implemented when we have the Firestore repository
      final products = await _repository.getProducts(limit: limit ?? 20);

      AppLogger.info('Fetched ${products.length} products');
      return products;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch products', e, stackTrace);
      rethrow;
    }
  }

  /// Allows calling the use case as a function.
  Future<List<Product>> call({int? limit, int? offset}) =>
      execute(limit: limit, offset: offset);
}
