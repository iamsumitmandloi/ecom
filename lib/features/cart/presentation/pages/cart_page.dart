import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecom/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecom/features/cart/presentation/widgets/cart_item_widget.dart';
import 'package:ecom/features/cart/presentation/widgets/cart_summary_widget.dart';
import 'package:ecom/features/cart/presentation/widgets/empty_cart_widget.dart';
import 'package:go_router/go_router.dart';

/// Shopping cart page displaying cart items and checkout summary.
///
/// Features:
/// - Cart item list with quantity controls
/// - Price calculations (subtotal, tax, shipping, total)
/// - Empty cart state
/// - Loading and error states
/// - Checkout button
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Shopping Cart'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return state.maybeWhen(
                loaded: (cart) => cart.isNotEmpty
                    ? TextButton(
                        onPressed: () => _showClearCartDialog(context),
                        child: const Text('Clear'),
                      )
                    : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (cart) {
              if (cart.isEmpty) {
                return const EmptyCartWidget();
              }

              return Column(
                children: [
                  // Cart items list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CartItemWidget(
                            item: item,
                            onQuantityChanged: (newQuantity) {
                              context.read<CartCubit>().updateQuantity(
                                    item.product.id,
                                    newQuantity,
                                  );
                            },
                            onRemove: () {
                              context.read<CartCubit>().removeProduct(
                                    item.product.id,
                                  );
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  // Cart summary and checkout
                  CartSummaryWidget(cart: cart),
                ],
              );
            },
            error: (message, lastCart) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading cart',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartCubit>().loadCart();
                    },
                    child: const Text('Retry'),
                  ),
                  if (lastCart != null && lastCart.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Show last known cart state
                        context.read<CartCubit>().loadCart();
                      },
                      child: const Text('Show Last Cart'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showClearCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<CartCubit>().clearCart();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
