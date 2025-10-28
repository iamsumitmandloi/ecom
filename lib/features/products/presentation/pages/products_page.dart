import 'package:ecom/core/widgets/connectivity_banner.dart';
import 'package:ecom/features/cart/presentation/widgets/floating_cart_button.dart';
import 'package:ecom/features/products/presentation/cubit/products_cubit.dart';
import 'package:ecom/features/products/presentation/cubit/products_state.dart';
import 'package:ecom/features/products/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Products list page showing all products.
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load products on init
    context.read<ProductsCubit>().loadProducts();

    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Load more when user is near the bottom of the list
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<ProductsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: BlocConsumer<ProductsCubit, ProductsState>(
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
                  loaded: (products, categories, hasMore) {
                    return RefreshIndicator(
                      onRefresh: () => context.read<ProductsCubit>().refresh(),
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          // Products grid
                          if (products.isEmpty)
                            const SliverFillRemaining(
                              child: Center(
                                child: Text(
                                  'No products found',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                          else
                            SliverPadding(
                              padding: const EdgeInsets.all(8),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    return ProductCard(
                                        product: products[index]);
                                  },
                                  childCount: products.length,
                                ),
                              ),
                            ),

                          // Loading more indicator
                          if (hasMore)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                          onPressed: () =>
                              context.read<ProductsCubit>().loadProducts(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: const FloatingCartButton(),
    );
  }
}
