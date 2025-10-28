import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/products/domain/errors/product_exceptions.dart';
import 'package:ecom/features/products/domain/usecases/get_product_by_id_use_case.dart';
import 'package:ecom/features/products/presentation/cubit/product_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing product detail state.
///
/// Handles loading a single product by ID.
class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductByIdUseCase _getProductByIdUseCase;

  ProductDetailCubit({required GetProductByIdUseCase getProductByIdUseCase})
    : _getProductByIdUseCase = getProductByIdUseCase,
      super(const ProductDetailState.initial());

  /// Load product details by ID
  Future<void> loadProduct(String productId) async {
    emit(const ProductDetailState.loading());

    try {
      AppLogger.info('Loading product details: $productId');

      final product = await _getProductByIdUseCase.execute(productId);

      AppLogger.info('Product details loaded: ${product.name}');

      emit(ProductDetailState.loaded(product: product));
    } on InvalidProductIdException catch (e) {
      AppLogger.warning('Invalid product ID', e);
      emit(ProductDetailState.error(message: e.message));
    } on ProductNotFoundException catch (e) {
      AppLogger.warning('Product not found', e);
      emit(ProductDetailState.error(message: e.message));
    } on ProductException catch (e) {
      AppLogger.error('Failed to load product', e);
      emit(ProductDetailState.error(message: e.message));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error loading product', e, stackTrace);
      emit(
        const ProductDetailState.error(
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Refresh product details
  Future<void> refresh() async {
    state.whenOrNull(
      loaded: (product) {
        return loadProduct(product.id);
      },
    );
  }
}
