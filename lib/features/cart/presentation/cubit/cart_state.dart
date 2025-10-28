import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ecom/features/cart/domain/entities/cart.dart';

part 'cart_state.freezed.dart';

/// Cart state representing different states of the shopping cart.
@freezed
class CartState with _$CartState {
  const factory CartState.initial() = CartInitial;
  const factory CartState.loading() = CartLoading;
  const factory CartState.loaded({required Cart cart}) = CartLoaded;
  const factory CartState.error({required String message, Cart? lastCart}) =
      CartError;
}
