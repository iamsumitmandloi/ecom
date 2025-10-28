import 'package:ecom/features/products/domain/entities/category.dart';
import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'products_state.freezed.dart';

/// State for products list screen
@freezed
class ProductsState with _$ProductsState {
  const factory ProductsState.initial() = _ProductsInitial;
  const factory ProductsState.loading() = _ProductsLoading;
  const factory ProductsState.loaded({
    required List<Product> products,
    required List<Category> categories,
    @Default(false) bool hasMore,
  }) = _ProductsLoaded;
  const factory ProductsState.error({required String message}) = _ProductsError;
}
