import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecom/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecom/features/cart/presentation/cubit/cart_state.dart';
import 'package:ecom/features/products/domain/entities/product.dart';
import 'package:go_router/go_router.dart';

/// Button for adding products to cart.
///
/// Features:
/// - Shows current cart quantity for the product
/// - Handles out-of-stock states
/// - Loading states during add operation
/// - Success feedback
class AddToCartButton extends StatefulWidget {
  final Product product;
  final bool showQuantity;

  const AddToCartButton({
    required this.product,
    this.showQuantity = true,
    super.key,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        final cartQuantity = context.read<CartCubit>().getProductQuantity(
              widget.product.id,
            );

        final isInCart = cartQuantity > 0;
        final isOutOfStock = !widget.product.isInStock;

        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: _buildButton(
                context,
                cartQuantity,
                isInCart,
                isOutOfStock,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildButton(
    BuildContext context,
    int cartQuantity,
    bool isInCart,
    bool isOutOfStock,
  ) {
    if (isOutOfStock) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.remove_shopping_cart),
          label: const Text('Out of Stock'),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.grey),
        ),
      );
    }

    if (isInCart && widget.showQuantity) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // Decrement button
            IconButton(
              onPressed: _isAdding ? null : () => _decrementQuantity(context),
              icon: const Icon(Icons.remove),
              iconSize: 18,
            ),

            // Quantity display
            Expanded(
              child: Text(
                '$cartQuantity',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),

            // Increment button
            IconButton(
              onPressed: _isAdding ? null : () => _incrementQuantity(context),
              icon: const Icon(Icons.add),
              iconSize: 18,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isAdding ? null : () => _addToCart(context),
        icon: _isAdding
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add_shopping_cart),
        label: Text(_isAdding ? 'Adding...' : 'Add to Cart'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context) async {
    setState(() {
      _isAdding = true;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Store context references before async operations
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      await context.read<CartCubit>().addProduct(widget.product);

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('${widget.product.name} added to cart'),
            duration: const Duration(seconds: 2),
            action: SnackBarAction(
              label: 'View Cart',
              onPressed: () {
                context.push('/cart');
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Failed to add to cart: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  Future<void> _incrementQuantity(BuildContext context) async {
    await context.read<CartCubit>().incrementQuantity(widget.product.id);
  }

  Future<void> _decrementQuantity(BuildContext context) async {
    await context.read<CartCubit>().decrementQuantity(widget.product.id);
  }
}
