import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_detail_state.freezed.dart';

/// State for product detail screen
@freezed
class ProductDetailState with _$ProductDetailState {
  const factory ProductDetailState.initial() = _ProductDetailInitial;
  const factory ProductDetailState.loading() = _ProductDetailLoading;
  const factory ProductDetailState.loaded({required Product product}) =
      _ProductDetailLoaded;
  const factory ProductDetailState.error({required String message}) =
      _ProductDetailError;
}
