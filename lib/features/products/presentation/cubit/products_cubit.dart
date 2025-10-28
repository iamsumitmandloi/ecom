import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:ecom/features/products/domain/errors/product_exceptions.dart';
import 'package:ecom/features/products/domain/usecases/get_categories_use_case.dart';
import 'package:ecom/features/products/domain/usecases/get_products_use_case.dart';
import 'package:ecom/features/products/presentation/cubit/products_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing products list state and operations.
///
/// Handles:
/// - Loading products
/// - Loading categories
/// - Pagination
class ProductsCubit extends Cubit<ProductsState> {
  final GetProductsUseCase _getProductsUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  bool _isLoadingMore = false;

  ProductsCubit({
    required GetProductsUseCase getProductsUseCase,
    required GetCategoriesUseCase getCategoriesUseCase,
  })  : _getProductsUseCase = getProductsUseCase,
        _getCategoriesUseCase = getCategoriesUseCase,
        super(const ProductsState.initial());

  /// Load initial products and categories
  Future<void> loadProducts() async {
    emit(const ProductsState.loading());

    try {
      AppLogger.info('Loading initial products');

      // Load products and categories in parallel
      final results = await Future.wait([
        _getProductsUseCase.execute(limit: 20),
        _getCategoriesUseCase.execute(),
      ]);

      final products = results[0] as List<Product>;
      final categories = results[1] as List;

      AppLogger.info(
        'Products loaded successfully: ${products.length} products, ${categories.length} categories',
      );

      emit(
        ProductsState.loaded(
          products: products,
          categories: categories.cast(),
          hasMore: products.length >= 20,
        ),
      );
    } on ProductException catch (e) {
      AppLogger.error('Failed to load products', e);
      emit(ProductsState.error(message: e.message));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error loading products', e, stackTrace);
      emit(
        const ProductsState.error(
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Load more products (pagination)
  Future<void> loadMore() async {
    await state.maybeWhen(
      loaded: (currentProducts, categories, hasMore) async {
        // Prevent multiple concurrent requests and exit if no more products
        if (!hasMore || _isLoadingMore) return;

        _isLoadingMore = true;
        AppLogger.info('Loading more products...');

        try {
          // Get the last product's ID to use as a cursor
          final lastProductId =
              currentProducts.isNotEmpty ? currentProducts.last.id : null;

          final newProducts = await _getProductsUseCase.execute(
            limit: 20,
            startAfter: lastProductId,
          );

          emit(
            ProductsState.loaded(
              // Append new products to the existing list
              products: [...currentProducts, ...newProducts],
              categories: categories,
              // Update hasMore flag
              hasMore: newProducts.length >= 20,
            ),
          );
        } on ProductException catch (e) {
          AppLogger.error('Failed to load more products', e);
          // On error, keep the current products and stop pagination
          emit(
            ProductsState.loaded(
              products: currentProducts,
              categories: categories,
              hasMore: false,
            ),
          );
        } catch (e, stackTrace) {
          AppLogger.error(
              'Unexpected error loading more products', e, stackTrace);
          // On unexpected error, just stop and keep the current state
        } finally {
          _isLoadingMore = false;
        }
      },
      // Do nothing if the state is not 'loaded'
      orElse: () {},
    );
  }

  /// Refresh products
  Future<void> refresh() async {
    return loadProducts();
  }
}
