import 'package:dio/dio.dart';
import 'package:ecom/core/config/app_config.dart';
import 'package:ecom/features/auth/domain/errors/auth_exceptions.dart';

class AuthApi {
  final Dio _dio;

  AuthApi(this._dio);

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '${AppConfig.identityToolkitBaseUrl}/accounts:signUp',
        queryParameters: {'key': AppConfig.apiKey},
        data: {'email': email, 'password': password, 'returnSecureToken': true},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _asAuthException(e);
    }
  }

  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '${AppConfig.identityToolkitBaseUrl}/accounts:signInWithPassword',
        queryParameters: {'key': AppConfig.apiKey},
        data: {'email': email, 'password': password, 'returnSecureToken': true},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _asAuthException(e);
    }
  }

  Future<Map<String, dynamic>> refresh({required String refreshToken}) async {
    try {
      final response = await _dio.post(
        '${AppConfig.secureTokenBaseUrl}/token',
        queryParameters: {'key': AppConfig.apiKey},
        data: {'grant_type': 'refresh_token', 'refresh_token': refreshToken},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _asAuthException(e);
    }
  }

  Exception _asAuthException(DioException e) {
    if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.sendTimeout || e.type == DioExceptionType.receiveTimeout) {
      return const NetworkError();
    }

    final errorCode = (e.response?.data is Map)
        ? ((e.response!.data as Map<String, dynamic>)['error']?['message']
                as String?)
        : null;

    if (errorCode == null) return const UnknownAuthError();

    switch (errorCode) {
      case 'EMAIL_EXISTS':
        return const EmailAlreadyInUse();
      case 'INVALID_PASSWORD':
      case 'EMAIL_NOT_FOUND':
        return const InvalidCredentials();
      case 'USER_DISABLED':
        return const UserDisabled();
      case 'WEAK_PASSWORD':
        return const WeakPassword('Password is too weak. It must be at least 6 characters long.');
      case 'TOO_MANY_ATTEMPTS_TRY_LATER':
        return const RateLimited();
      default:
        return const UnknownAuthError();
    }
  }
}
