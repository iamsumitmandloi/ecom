import 'package:ecom/core/network/dio_client.dart';
import 'package:ecom/core/storage/secure_session_storage.dart';
import 'package:ecom/core/storage/secure_session_storage_impl.dart';
import 'package:ecom/features/auth/data/auth_api.dart';
import 'package:ecom/features/auth/data/auth_repository_impl.dart';
import 'package:ecom/features/auth/domain/repositories/auth_repository.dart';

class AppDependencies {
  final SecureSessionStorage storage;
  final AuthApi authApi;
  final AuthRepository authRepository;
  final DioClient baseClient;
  final DioClient authedClient;

  AppDependencies._({
    required this.storage,
    required this.authApi,
    required this.authRepository,
    required this.baseClient,
    required this.authedClient,
  });

  factory AppDependencies.create() {
    final storage = SecureSessionStorageImpl();
    final base = DioClient.create();
    final authApi = AuthApi(base.dio);
    final repo = AuthRepositoryImpl(api: authApi, storage: storage);
    final authed = DioClient.create(
      addAuthInterceptor: true,
      storage: storage,
      authApi: authApi,
    );
    return AppDependencies._(
      storage: storage,
      authApi: authApi,
      authRepository: repo,
      baseClient: base,
      authedClient: authed,
    );
  }
}
