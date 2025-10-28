import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecom/features/cart/presentation/cubit/cart_state.dart';
import 'package:go_router/go_router.dart';

/// Floating action button showing cart item count.
///
/// Features:
/// - Shows current item count
/// - Navigates to cart page
/// - Animated badge
/// - Hides when cart is empty
class FloatingCartButton extends StatelessWidget {
  const FloatingCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final itemCount = state.maybeWhen(
          loaded: (cart) => cart.itemCount,
          orElse: () => 0,
        );

        if (itemCount == 0) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: () {
            context.push('/cart');
          },
          child: Stack(
            children: [
              const Icon(Icons.shopping_cart),
              if (itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Text(
                      '$itemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
