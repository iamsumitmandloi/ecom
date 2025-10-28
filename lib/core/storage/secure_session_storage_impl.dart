import 'dart:convert';

import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/core/storage/secure_session_storage.dart';
import 'package:ecom/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureSessionStorageImpl implements SecureSessionStorage {
  static const String _key = 'auth_session';
  final FlutterSecureStorage _storage;

  SecureSessionStorageImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<void> clearSession() async {
    await _storage.delete(key: _key);
  }

  @override
  Future<AuthSession?> readSession() async {
    final jsonStr = await _storage.read(key: _key);
    if (jsonStr == null || jsonStr.isEmpty) {
      return null;
    }

    try {
      final map = json.decode(jsonStr) as Map<String, dynamic>;
      return AuthSession.fromJson(map);
    } catch (e, stackTrace) {
      // If parsing fails, the session is corrupt.
      // Log the error, clear the bad data, and treat as no session found.
      AppLogger.error('Failed to parse session from storage', e, stackTrace);
      await clearSession();
      return null;
    }
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    await _storage.write(key: _key, value: json.encode(session.toJson()));
  }
}
