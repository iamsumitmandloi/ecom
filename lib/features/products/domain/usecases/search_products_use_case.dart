// import 'package:ecom/core/logging/app_logger.dart';
// import 'package:ecom/features/products/domain/entities/product.dart';
// import 'package:ecom/features/products/domain/errors/product_exceptions.dart';
// import 'package:ecom/features/products/domain/repositories/products_repository.dart';
//
// /// Use case for searching products by query.
// ///
// /// Encapsulates business logic for:
// /// - Query validation (minimum length)
// /// - Logging search queries
// /// - Search result tracking
// ///
// /// Example:
// /// ```dart
// /// final results = await searchProductsUseCase.execute(
// ///   query: 'laptop',
// ///   limit: 10,
// /// );
// /// ```
// class SearchProductsUseCase {
//   final ProductsRepository _repository;
//
//   /// Minimum query length required for search
//   static const int minQueryLength = 3;
//
//   const SearchProductsUseCase({required ProductsRepository repository})
//     : _repository = repository;
//
//   /// Execute the use case to search products.
//   ///
//   /// Parameters:
//   /// - [query]: Search query string
//   /// - [limit]: Maximum number of results (default: 20)
//   ///
//   /// Returns list of products matching the query.
//   /// Throws [InvalidSearchQueryException] if query is too short.
//   Future<List<Product>> execute({required String query, int limit = 20}) async {
//     // Validate query length
//     final trimmedQuery = query.trim();
//     if (trimmedQuery.length < minQueryLength) {
//       throw InvalidSearchQueryException(
//         'Search query must be at least $minQueryLength characters',
//       );
//     }
//
//     AppLogger.info('Searching products: "$trimmedQuery"');
//
//     try {
//       final products = await _repository.searchProducts(
//         query: trimmedQuery,
//         limit: limit,
//       );
//
//       AppLogger.info(
//         'Search completed: "$trimmedQuery" - ${products.length} results',
//       );
//       return products;
//     } catch (e, stackTrace) {
//       AppLogger.error('Search failed: "$trimmedQuery"', e, stackTrace);
//       rethrow;
//     }
//   }
//
//   /// Allows calling the use case as a function.
//   Future<List<Product>> call({required String query, int limit = 20}) =>
//       execute(query: query, limit: limit);
// }
