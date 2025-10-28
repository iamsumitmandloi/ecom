import 'dart:async';

import 'package:dio/dio.dart';
import 'package:ecom/core/storage/secure_session_storage.dart';
import 'package:ecom/features/auth/data/auth_api.dart';
import 'package:ecom/features/auth/domain/entities/auth_session.dart';

class AuthInterceptor extends Interceptor {
  final SecureSessionStorage storage;
  final AuthApi api;
  final Dio dio;

  Future<AuthSession?> _refreshing;

  AuthInterceptor({required this.storage, required this.api, required this.dio})
    : _refreshing = Future.value(null);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final session = await storage.readSession();
    if (session != null && !session.isExpired) {
      options.headers['Authorization'] = 'Bearer ${session.idToken}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final orig = err.requestOptions;
      try {
        final session = await storage.readSession();
        if (session == null) return handler.next(err);

        if (_refreshing is! Future<AuthSession>) {
          _refreshing = _doRefresh(session);
        }
        final refreshed = await _refreshing;
        _refreshing = Future.value(null);

        if (refreshed == null) return handler.next(err);

        final req = await _retryRequest(orig, refreshed.idToken);
        return handler.resolve(req);
      } catch (_) {
        return handler.next(err);
      }
    }
    handler.next(err);
  }

  Future<AuthSession> _doRefresh(AuthSession session) async {
    final data = await api.refresh(refreshToken: session.refreshToken);
    final expiresIn =
        int.tryParse((data['expires_in'] ?? data['expiresIn']).toString()) ??
        3600;
    final refreshed = AuthSession(
      idToken: data['id_token'] ?? data['idToken'],
      refreshToken: data['refresh_token'] ?? data['refreshToken'],
      expiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
      userId: data['user_id'] ?? data['localId'] ?? session.userId,
    );
    // Repository is responsible for saving session, not interceptor
    // But we need to save here temporarily to keep the session valid
    await storage.saveSession(refreshed);
    return refreshed;
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String idToken,
  ) async {
    final newOptions = requestOptions.copyWith(
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $idToken'},
    );
    return dio.fetch(newOptions);
  }
}
