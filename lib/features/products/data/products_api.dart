import 'package:dio/dio.dart';
import 'package:ecom/core/config/app_config.dart';
import 'package:ecom/core/logging/app_logger.dart';

/// API client for Firestore products REST endpoints.
///
/// Handles all HTTP communication with Firestore for products and categories.
/// Uses authenticated Dio client for all requests.
class ProductsApi {
  final Dio _dio;
  final String _projectId = AppConfig.firebaseProjectId;

  ProductsApi(this._dio);

  /// Base Firestore REST URL
  String get _baseUrl =>
      'https://firestore.googleapis.com/v1/projects/$_projectId/databases/(default)/documents';

  /// Get list of products with pagination
  ///
  /// Parameters:
  /// - [limit]: Maximum number of products to return
  /// - [startAfter]: Document ID to start after (for pagination)
  /// - [orderBy]: Field to order by
  /// - [descending]: Whether to order in descending order
  ///
  /// Returns Firestore documents array
  Future<Map<String, dynamic>> getProducts({
    int limit = 20,
    String? startAfter,
    String orderBy = 'createdAt',
    bool descending = true,
  }) async {
    try {
      AppLogger.debug(
        'Fetching products: limit=$limit, orderBy=$orderBy',
      );

      // Build structured query
      final query = <String, dynamic>{
        'structuredQuery': <String, dynamic>{
          'from': [
            {'collectionId': 'products'},
          ],
          'orderBy': [
            {
              'field': {'fieldPath': orderBy},
              'direction': descending ? 'DESCENDING' : 'ASCENDING',
            },
          ],
          'limit': limit,
          if (startAfter != null)
            'startAt': {
              'values': [
                {'referenceValue': '$_baseUrl/products/$startAfter'},
              ],
              'before': false,
            },
        },
      };

      final response = await _dio.post('$_baseUrl:runQuery', data: query);

      AppLogger.debug('Products fetched successfully');
      return {'documents': response.data as List<dynamic>};
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch products', e);
      rethrow;
    }
  }

  /// Get a single product by ID
  ///
  /// Parameters:
  /// - [productId]: Unique identifier of the product
  ///
  /// Returns Firestore document
  Future<Map<String, dynamic>> getProductById(String productId) async {
    try {
      AppLogger.debug('Fetching product: $productId');

      final response = await _dio.get('$_baseUrl/products/$productId');

      AppLogger.debug('Product fetched successfully');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch product: $productId', e);
      rethrow;
    }
  }

  /// Get all categories
  ///
  /// Returns Firestore documents array
  Future<Map<String, dynamic>> getCategories() async {
    try {
      AppLogger.debug('Fetching categories');

      final structuredQuery = {
        'structuredQuery': {
          'from': [
            {'collectionId': 'categories'},
          ],
          'orderBy': [
            {
              'field': {'fieldPath': 'name'},
              'direction': 'ASCENDING',
            },
          ],
        },
      };

      final response = await _dio.post(
        '$_baseUrl:runQuery',
        data: structuredQuery,
      );

      AppLogger.debug('Categories fetched successfully');
      return {'documents': response.data as List<dynamic>};
    } on DioException catch (e) {
      AppLogger.error('Failed to fetch categories', e);
      rethrow;
    }
  }
}
