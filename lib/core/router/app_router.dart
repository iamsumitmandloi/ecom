import 'dart:async';

import 'package:ecom/core/di/service_locator.dart';
import 'package:ecom/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecom/features/auth/presentation/cubit/auth_state.dart';
import 'package:ecom/features/auth/presentation/pages/auth_page.dart';
import 'package:ecom/features/cart/presentation/pages/cart_page.dart';
import 'package:ecom/features/products/presentation/cubit/products_cubit.dart';
import 'package:ecom/features/products/presentation/pages/product_detail_page.dart';
import 'package:ecom/features/products/presentation/pages/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthCubit authCubit;

  AppRouter({required this.authCubit});

  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt<ProductsCubit>(),
            child: const ProductsPage(),
          );
        },
      ),
      // New route for Product Detail
      GoRoute(
        path: '/product/:id',
        builder: (context, state) {
          final productId = state.pathParameters['id'];

          if (productId == null) {
            // A simple guard against a null ID.
            // TODO:  you might want to show a "Not Found" page.
            return const ProductsPage();
          }
          return ProductDetailPage(productId: productId);
        },
      ),
      // New route for Cart
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final authState = authCubit.state;
      final location = state.matchedLocation;

      // While the auth state is loading, stay on the splash page
      final isLoading = authState.whenOrNull(loading: () => true) ?? false;
      if (isLoading) {
        return '/';
      }

      final isAuthenticated =
          authState.whenOrNull(authenticated: (_, __) => true) ?? false;

      // If the user is on the splash page after loading, redirect them.
      if (location == '/') {
        return isAuthenticated ? '/products' : '/login';
      }

      // If the user is authenticated but trying to access login, redirect to products.
      if (isAuthenticated && location == '/login') {
        return '/products';
      }

      // If the user is not authenticated and trying to access a protected page, redirect to login.
      if (!isAuthenticated && location != '/login') {
        return '/login';
      }

      // Otherwise, no redirect is necessary.
      return null;
    },
    refreshListenable: _GoRouterRefreshStream(authCubit.stream),
  );
}

// This helper class converts a Stream into a Listenable for GoRouter.
class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
