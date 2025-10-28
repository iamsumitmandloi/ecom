import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/products/domain/entities/category.dart';
import 'package:ecom/features/products/domain/repositories/products_repository.dart';

/// Use case for fetching product categories.
///
/// Encapsulates business logic for:
/// - Logging category fetches
/// - Filtering empty categories (optional)
///
/// Example:
/// ```dart
/// final categories = await getCategoriesUseCase.execute();
/// ```
class GetCategoriesUseCase {
  final ProductsRepository _repository;

  const GetCategoriesUseCase({required ProductsRepository repository})
      : _repository = repository;

  /// Execute the use case to fetch categories.
  ///
  /// Returns list of categories.
  Future<List<Category>> execute() async {
    AppLogger.info('Fetching categories');

    try {
      final categories = await _repository.getCategories();
      AppLogger.info('Fetched ${categories.length} categories');
      return categories;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to fetch categories', e, stackTrace);
      rethrow;
    }
  }

  /// Allows calling the use case as a function.
  Future<List<Category>> call() => execute();
}

