import 'package:ecom/core/di/service_locator.dart';
import 'package:ecom/core/widgets/connectivity_banner.dart';
import 'package:ecom/features/cart/presentation/widgets/add_to_cart_button.dart';
import 'package:ecom/features/products/presentation/cubit/product_detail_cubit.dart';
import 'package:ecom/features/products/presentation/cubit/product_detail_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Product detail page showing full product information.
class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({required this.productId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductDetailCubit>()..loadProduct(productId),
      child: Scaffold(
        body: Column(
          children: [
            const ConnectivityBanner(),
            Expanded(
              child: BlocConsumer<ProductDetailCubit, ProductDetailState>(
                listener: (context, state) {
                  state.whenOrNull(
                    error: (message) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    },
                  );
                },
                builder: (context, state) {
                  return state.when(
                    initial: () =>
                        const Center(child: CircularProgressIndicator()),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    loaded: (product) {
                      return CustomScrollView(
                        slivers: [
                          // App Bar with Image
                          SliverAppBar(
                            expandedHeight: 300,
                            pinned: true,
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => context.pop(),
                            ),
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                color: Colors.grey[200],
                                child: product.imageUrl.isNotEmpty
                                    ? Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(
                                              Icons.image_not_supported,
                                              size: 64,
                                            ),
                                      )
                                    : const Icon(Icons.shopping_bag, size: 64),
                              ),
                            ),
                          ),

                          // Product Info
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Name
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Category
                                  Chip(
                                    label: Text(product.category),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                  ),
                                  const SizedBox(height: 16),

                                  // Rating
                                  if (product.hasRatings)
                                    Row(
                                      children: [
                                        ...List.generate(
                                          5,
                                          (index) => Icon(
                                            index < product.rating.floor()
                                                ? Icons.star
                                                : Icons.star_border,
                                            color: Colors.amber,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          product.ratingText,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 16),

                                  // Price and Stock
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        product.formattedPrice,
                                        style: TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: product.isOutOfStock
                                              ? Colors.red
                                              : product.isLowStock
                                              ? Colors.orange
                                              : Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                        child: Text(
                                          product.stockStatus,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 32),

                                  // Description
                                  const Text(
                                    'Description',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.description,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      height: 1.5,
                                    ),
                                  ),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    error: (message) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppBar(
                            title: const Text('Product Details'),
                            leading: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () => context.pop(),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<ProductDetailCubit>()
                                .loadProduct(productId),
                            child: const Text('Retry'),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            return state.maybeWhen(
              loaded: (product) => SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AddToCartButton(
                    product: product,
                    showQuantity: true,
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            );
          },
        ),
      ),
    );
  }
}
