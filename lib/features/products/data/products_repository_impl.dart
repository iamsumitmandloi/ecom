import 'package:dio/dio.dart';
import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/products/data/models/category_model.dart';
import 'package:ecom/features/products/data/models/product_model.dart';
import 'package:ecom/features/products/data/products_api.dart';
import 'package:ecom/features/products/domain/entities/category.dart';
import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:ecom/features/products/domain/errors/product_exceptions.dart';
import 'package:ecom/features/products/domain/repositories/products_repository.dart';

/// Implementation of ProductsRepository using Firestore REST API.
///
/// Handles data transformation between API responses and domain entities.
/// Maps HTTP errors to domain-specific exceptions.
class ProductsRepositoryImpl implements ProductsRepository {
  final ProductsApi _api;

  ProductsRepositoryImpl({required ProductsApi api}) : _api = api;

  @override
  Future<List<Product>> getProducts({
    int limit = 20,
    String? startAfter,
    String orderBy = 'createdAt',
    bool descending = true,
  }) async {
    try {
      final response = await _api.getProducts(
        limit: limit,
        startAfter: startAfter,
        orderBy: orderBy,
        descending: descending,
      );

      // Parse Firestore response
      final documents =
          (response['documents'] ?? response) as List<dynamic>? ?? [];

      final products = documents
          .where((doc) => doc['document'] != null)
          .map((doc) {
            try {
              final model = ProductModel.fromFirestore(
                doc['document'] as Map<String, dynamic>,
              );
              return model.toEntity();
            } catch (e) {
              AppLogger.warning('Failed to parse product document', e);
              return null;
            }
          })
          .whereType<Product>()
          .toList();

      AppLogger.info('Successfully fetched ${products.length} products');
      return products;
    } on DioException catch (e) {
      throw _mapException(e, 'Failed to fetch products');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching products', e, stackTrace);
      throw const ProductFetchException('An unexpected error occurred');
    }
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await _api.getProductById(id);

      final model = ProductModel.fromFirestore(response);
      final product = model.toEntity();

      AppLogger.info('Successfully fetched product: ${product.name}');
      return product;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        throw ProductNotFoundException('Product not found: $id');
      }
      throw _mapException(e, 'Failed to fetch product');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching product', e, stackTrace);
      throw const ProductFetchException('An unexpected error occurred');
    }
  }

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await _api.getCategories();

      // Parse Firestore response
      final documents =
          (response['documents'] ?? response) as List<dynamic>? ?? [];

      final categories = documents
          .where((doc) => doc['document'] != null)
          .map((doc) {
            try {
              final model = CategoryModel.fromFirestore(
                doc['document'] as Map<String, dynamic>,
              );
              return model.toEntity();
            } catch (e) {
              AppLogger.warning('Failed to parse category document', e);
              return null;
            }
          })
          .whereType<Category>()
          .toList();

      AppLogger.info('Successfully fetched ${categories.length} categories');
      return categories;
    } on DioException catch (e) {
      throw _mapException(e, 'Failed to fetch categories');
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error fetching categories', e, stackTrace);
      throw const ProductFetchException('An unexpected error occurred');
    }
  }

  @override
  Future<Product> toggleFavorite({
    required String productId,
    required bool isFavorite,
  }) async {
    // TODO: Implement when we add user favorites feature
    throw UnimplementedError('Favorites feature not yet implemented');
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    // TODO: Implement when we add user favorites feature
    throw UnimplementedError('Favorites feature not yet implemented');
  }

  /// Map DioException to domain-specific exception
  ProductException _mapException(DioException e, String message) {
    AppLogger.error(message, e);

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const ProductFetchException('Request timeout');
    }

    if (e.type == DioExceptionType.connectionError) {
      return const ProductFetchException('Network connection error');
    }

    final statusCode = e.response?.statusCode;
    if (statusCode == 404) {
      return const ProductNotFoundException('Resource not found');
    }

    if (statusCode == 403) {
      return const ProductFetchException('Access denied');
    }

    if (statusCode != null && statusCode >= 500) {
      return const ProductFetchException('Server error');
    }

    return ProductFetchException(message);
  }
}
