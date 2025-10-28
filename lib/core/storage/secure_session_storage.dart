import 'package:ecom/features/auth/domain/entities/auth_session.dart';

/// Interface for secure session storage operations.
abstract class SecureSessionStorage {
  Future<void> saveSession(AuthSession session);
  Future<AuthSession?> readSession();
  Future<void> clearSession();
}
