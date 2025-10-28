import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecom/core/network/dio_client.dart';
import 'package:ecom/core/network/network_info.dart';
import 'package:ecom/core/storage/secure_session_storage.dart';
import 'package:ecom/core/storage/secure_session_storage_impl.dart';
import 'package:ecom/core/storage/secure_storage.dart';
import 'package:ecom/core/storage/secure_storage_impl.dart';
import 'package:ecom/features/auth/data/auth_api.dart';
import 'package:ecom/features/auth/data/auth_repository_impl.dart';
import 'package:ecom/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecom/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecom/features/cart/data/cart_repository_impl.dart';
import 'package:ecom/features/cart/data/cart_storage.dart';
import 'package:ecom/features/cart/domain/repositories/cart_repository.dart';
import 'package:ecom/features/cart/domain/usecases/add_to_cart_use_case.dart';
import 'package:ecom/features/cart/domain/usecases/clear_cart_use_case.dart';
import 'package:ecom/features/cart/domain/usecases/remove_from_cart_use_case.dart';
import 'package:ecom/features/cart/domain/usecases/update_cart_quantity_use_case.dart';
import 'package:ecom/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:ecom/features/products/data/products_api.dart';
import 'package:ecom/features/products/data/products_repository_impl.dart';
import 'package:ecom/features/products/domain/repositories/products_repository.dart';
import 'package:ecom/features/products/domain/usecases/get_categories_use_case.dart';
import 'package:ecom/features/products/domain/usecases/get_product_by_id_use_case.dart';
import 'package:ecom/features/products/domain/usecases/get_products_use_case.dart';
import 'package:ecom/features/products/domain/usecases/search_products_use_case.dart';
import 'package:ecom/features/products/presentation/cubit/product_detail_cubit.dart';
import 'package:ecom/features/products/presentation/cubit/products_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core - Network Info
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectivity: Connectivity()),
  );

  // Core - Storage
  getIt.registerLazySingleton<SecureSessionStorage>(
    () => SecureSessionStorageImpl(),
  );

  getIt.registerLazySingleton<SecureStorage>(() => SecureStorageImpl());

  // Core - Network (base Dio for AuthApi, no interceptor)
  getIt.registerLazySingleton<DioClient>(
    () => DioClient.create(),
    instanceName: 'baseClient',
  );

  // Auth - API
  getIt.registerLazySingleton<AuthApi>(
    () => AuthApi(getIt<DioClient>(instanceName: 'baseClient').dio),
  );

  // Auth - Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      api: getIt<AuthApi>(),
      storage: getIt<SecureSessionStorage>(),
    ),
  );

  // Network client with auth interceptor (for future features)
  getIt.registerLazySingleton<DioClient>(
    () => DioClient.create(
      addAuthInterceptor: true,
      storage: getIt<SecureSessionStorage>(),
      authApi: getIt<AuthApi>(),
    ),
    instanceName: 'authClient',
  );

  // ============================================================================
  // Auth Feature
  // ============================================================================

  // Auth - Cubit
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      repository: getIt<AuthRepository>(),
      storage: getIt<SecureSessionStorage>(),
    ),
  );

  // ============================================================================
  // Products Feature
  // ============================================================================

  // Products - API
  getIt.registerLazySingleton<ProductsApi>(
    () => ProductsApi(getIt<DioClient>(instanceName: 'authClient').dio),
  );

  // Products - Repository
  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepositoryImpl(api: getIt<ProductsApi>()),
  );

  // Products - Use Cases
  getIt.registerLazySingleton<GetProductsUseCase>(
    () => GetProductsUseCase(repository: getIt<ProductsRepository>()),
  );

  getIt.registerLazySingleton<GetProductByIdUseCase>(
    () => GetProductByIdUseCase(repository: getIt<ProductsRepository>()),
  );

  // getIt.registerLazySingleton<SearchProductsUseCase>(
  //   () => SearchProductsUseCase(repository: getIt<ProductsRepository>()),
  // );

  getIt.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(repository: getIt<ProductsRepository>()),
  );

  // Products - Cubits
  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(
      getProductsUseCase: getIt<GetProductsUseCase>(),
      getCategoriesUseCase: getIt<GetCategoriesUseCase>(),
      // searchProductsUseCase: getIt<SearchProductsUseCase>(),
    ),
  );

  getIt.registerFactory<ProductDetailCubit>(
    () => ProductDetailCubit(
      getProductByIdUseCase: getIt<GetProductByIdUseCase>(),
    ),
  );

  // ============================================================================
  // Cart Feature
  // ============================================================================

  // Cart - Storage
  getIt.registerLazySingleton<CartStorage>(
    () => CartStorageImpl(storage: getIt<SecureStorage>()),
  );

  // Cart - Repository
  getIt.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(storage: getIt<CartStorage>()),
  );

  // Cart - Use Cases
  getIt.registerLazySingleton<AddToCartUseCase>(
    () => AddToCartUseCase(repository: getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<RemoveFromCartUseCase>(
    () => RemoveFromCartUseCase(repository: getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<UpdateCartQuantityUseCase>(
    () => UpdateCartQuantityUseCase(repository: getIt<CartRepository>()),
  );

  getIt.registerLazySingleton<ClearCartUseCase>(
    () => ClearCartUseCase(repository: getIt<CartRepository>()),
  );

  // Cart - Cubit (Singleton to avoid multiple instances)
  getIt.registerLazySingleton<CartCubit>(
    () => CartCubit(
      repository: getIt<CartRepository>(),
      addToCartUseCase: getIt<AddToCartUseCase>(),
      removeFromCartUseCase: getIt<RemoveFromCartUseCase>(),
      updateQuantityUseCase: getIt<UpdateCartQuantityUseCase>(),
      clearCartUseCase: getIt<ClearCartUseCase>(),
    ),
  );
}
