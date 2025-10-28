import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/core/network/auth_interceptor.dart';
import 'package:ecom/core/storage/secure_session_storage.dart';
import 'package:ecom/features/auth/data/auth_api.dart';

class DioClient {
  final Dio dio;

  DioClient._(this.dio);

  static DioClient create({
    Duration timeout = const Duration(seconds: 20),
    SecureSessionStorage? storage,
    AuthApi? authApi,
    bool addAuthInterceptor = false,
  }) {
    final dio = Dio(
      BaseOptions(
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        contentType: 'application/json',
        responseType: ResponseType.json,
      ),
    );

    // Add retry interceptor first (retries before auth refresh)
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: (message) => AppLogger.debug('[Retry] $message'),
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1), // First retry after 1s
          Duration(seconds: 2), // Second retry after 2s
          Duration(seconds: 3), // Third retry after 3s
        ],
        retryableExtraStatuses: {408}, // Request Timeout
      ),
    );

    // Add auth interceptor last (after retries)
    if (addAuthInterceptor && storage != null && authApi != null) {
      dio.interceptors.add(
        AuthInterceptor(storage: storage, api: authApi, dio: dio),
      );
    }

    return DioClient._(dio);
  }
}
