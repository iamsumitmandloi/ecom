import 'package:ecom/core/di/service_locator.dart';
import 'package:ecom/core/router/app_router.dart';
import 'package:ecom/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:ecom/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthCubit>()..restore()),
        BlocProvider(create: (_) => getIt<CartCubit>()..loadCart()),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    final router = AppRouter(authCubit: context.read<AuthCubit>()).router;

    return MaterialApp.router(
      title: 'E-commerce App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 109, 103, 120),
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
