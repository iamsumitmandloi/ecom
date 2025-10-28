import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/features/cart/domain/entities/cart.dart';
import 'package:ecom/features/cart/domain/errors/cart_exceptions.dart';
import 'package:ecom/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecom/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:ecom/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:ecom/features/cart/domain/usecases/update_cart_quantity_use_case.dart';
import 'package:ecom/features/cart/domain/usecases/clear_cart_use_case.dart';
import 'package:ecom/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecom/features/products/domain/entities/product.dart';

/// Cubit for managing shopping cart state and operations.
///
/// Handles:
/// - Cart loading and persistence
/// - Adding/removing products
/// - Quantity updates
/// - Error handling
/// - State management
class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;
  final AddToCartUseCase _addToCartUseCase;
  final RemoveFromCartUseCase _removeFromCartUseCase;
  final UpdateCartQuantityUseCase _updateQuantityUseCase;
  final ClearCartUseCase _clearCartUseCase;

  CartCubit({
    required CartRepository repository,
    required AddToCartUseCase addToCartUseCase,
    required RemoveFromCartUseCase removeFromCartUseCase,
    required UpdateCartQuantityUseCase updateQuantityUseCase,
    required ClearCartUseCase clearCartUseCase,
  }) : _repository = repository,
       _addToCartUseCase = addToCartUseCase,
       _removeFromCartUseCase = removeFromCartUseCase,
       _updateQuantityUseCase = updateQuantityUseCase,
       _clearCartUseCase = clearCartUseCase,
       super(const CartState.initial());

  /// Load cart from storage
  Future<void> loadCart() async {
    try {
      emit(const CartState.loading());
      AppLogger.info('Loading cart');

      final cart = await _repository.getCart();
      emit(CartState.loaded(cart: cart));

      AppLogger.info('Cart loaded successfully with ${cart.itemCount} items');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load cart', e, stackTrace);
      emit(CartState.error(message: 'Failed to load cart', lastCart: null));
    }
  }

  /// Add a product to the cart
  Future<void> addProduct(Product product, {int quantity = 1}) async {
    try {
      AppLogger.info('Adding product to cart: ${product.name}');

      final cart = await _addToCartUseCase.execute(product, quantity: quantity);
      emit(CartState.loaded(cart: cart));

      AppLogger.info('Product added to cart successfully');
    } on CartException catch (e) {
      AppLogger.warning('Cart operation failed: ${e.message}');
      emit(CartState.error(message: e.message, lastCart: _getCurrentCart()));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error adding product to cart', e, stackTrace);
      emit(
        CartState.error(
          message: 'An unexpected error occurred',
          lastCart: _getCurrentCart(),
        ),
      );
    }
  }

  /// Remove a product from the cart
  Future<void> removeProduct(String productId) async {
    try {
      AppLogger.info('Removing product from cart: $productId');

      final cart = await _removeFromCartUseCase.execute(productId);
      emit(CartState.loaded(cart: cart));

      AppLogger.info('Product removed from cart successfully');
    } on CartException catch (e) {
      AppLogger.warning('Cart operation failed: ${e.message}');
      emit(CartState.error(message: e.message, lastCart: _getCurrentCart()));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error removing product from cart',
        e,
        stackTrace,
      );
      emit(
        CartState.error(
          message: 'An unexpected error occurred',
          lastCart: _getCurrentCart(),
        ),
      );
    }
  }

  /// Update the quantity of a product in the cart
  Future<void> updateQuantity(String productId, int quantity) async {
    try {
      AppLogger.info(
        'Updating product quantity: $productId, quantity: $quantity',
      );

      final cart = await _updateQuantityUseCase.execute(productId, quantity);
      emit(CartState.loaded(cart: cart));

      AppLogger.info('Product quantity updated successfully');
    } on CartException catch (e) {
      AppLogger.warning('Cart operation failed: ${e.message}');
      emit(CartState.error(message: e.message, lastCart: _getCurrentCart()));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Unexpected error updating product quantity',
        e,
        stackTrace,
      );
      emit(
        CartState.error(
          message: 'An unexpected error occurred',
          lastCart: _getCurrentCart(),
        ),
      );
    }
  }

  /// Clear all items from the cart
  Future<void> clearCart() async {
    try {
      AppLogger.info('Clearing cart');

      final cart = await _clearCartUseCase.execute();
      emit(CartState.loaded(cart: cart));

      AppLogger.info('Cart cleared successfully');
    } on CartException catch (e) {
      AppLogger.warning('Cart operation failed: ${e.message}');
      emit(CartState.error(message: e.message, lastCart: _getCurrentCart()));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error clearing cart', e, stackTrace);
      emit(
        CartState.error(
          message: 'An unexpected error occurred',
          lastCart: _getCurrentCart(),
        ),
      );
    }
  }

  /// Increment quantity of a product by 1
  Future<void> incrementQuantity(String productId) async {
    final currentCart = _getCurrentCart();
    if (currentCart == null) return;

    final currentQuantity = currentCart.getProductQuantity(productId);
    await updateQuantity(productId, currentQuantity + 1);
  }

  /// Decrement quantity of a product by 1
  Future<void> decrementQuantity(String productId) async {
    final currentCart = _getCurrentCart();
    if (currentCart == null) return;

    final currentQuantity = currentCart.getProductQuantity(productId);
    if (currentQuantity <= 1) {
      await removeProduct(productId);
    } else {
      await updateQuantity(productId, currentQuantity - 1);
    }
  }

  /// Check if a product is in the cart
  bool containsProduct(String productId) {
    final cart = _getCurrentCart();
    return cart?.containsProduct(productId) ?? false;
  }

  /// Get quantity of a product in the cart
  int getProductQuantity(String productId) {
    final cart = _getCurrentCart();
    return cart?.getProductQuantity(productId) ?? 0;
  }

  /// Get current cart from state
  Cart? _getCurrentCart() {
    return state.maybeWhen(
      loaded: (cart) => cart,
      error: (message, lastCart) => lastCart,
      orElse: () => null,
    );
  }

  /// Get current item count
  int get itemCount {
    final cart = _getCurrentCart();
    return cart?.itemCount ?? 0;
  }

  /// Check if cart is empty
  bool get isEmpty {
    final cart = _getCurrentCart();
    return cart?.isEmpty ?? true;
  }

  /// Get cart total
  double get total {
    final cart = _getCurrentCart();
    return cart?.finalTotal ?? 0.0;
  }

  /// Get formatted cart total
  String get formattedTotal {
    final cart = _getCurrentCart();
    return cart?.formattedFinalTotal ?? '\$0.00';
  }
}
