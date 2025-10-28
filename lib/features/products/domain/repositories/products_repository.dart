import 'package:ecom/features/products/domain/entities/category.dart';
import 'package:ecom/features/products/domain/entities/product.dart';

/// Abstract repository interface for products operations.
///
/// Defines contracts for:
/// - Fetching products (list, detail)
/// - Managing categories
/// - Favorites management
///
/// Implementation will use Firestore REST API.
abstract class ProductsRepository {
  /// Get list of products with pagination.
  ///
  /// Parameters:
  /// - [limit]: Maximum number of products to return (default: 20)
  /// - [startAfter]: Document ID to start after (for pagination)
  /// - [orderBy]: Field to order by (e.g., 'price', 'name', 'createdAt')
  /// - [descending]: Whether to order in descending order
  ///
  /// Returns list of products matching the criteria.
  Future<List<Product>> getProducts({
    int limit = 20,
    String? startAfter,
    String orderBy = 'createdAt',
    bool descending = true,
  });

  /// Get a single product by ID.
  ///
  /// Throws [ProductNotFoundException] if product doesn't exist.
  Future<Product> getProductById(String productId);

  /// Get all available categories.
  ///
  /// Returns list of categories with product counts.
  Future<List<Category>> getCategories();

  /// Toggle favorite status for a product.
  ///
  /// Parameters:
  /// - [productId]: ID of the product
  /// - [isFavorite]: New favorite status
  ///
  /// Returns updated product.
  Future<Product> toggleFavorite({
    required String productId,
    required bool isFavorite,
  });

  /// Get user's favorite products.
  ///
  /// Returns list of products marked as favorite by current user.
  Future<List<Product>> getFavoriteProducts();
}
