import 'package:ecom/core/storage/secure_session_storage.dart';
import 'package:ecom/features/auth/data/auth_api.dart';
import 'package:ecom/features/auth/domain/entities/auth_session.dart';
import 'package:ecom/features/auth/domain/errors/auth_exceptions.dart';
import 'package:ecom/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecom/features/auth/domain/value_objects/credentials.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi api;
  final SecureSessionStorage storage;

  AuthRepositoryImpl({required this.api, required this.storage});

  @override
  Future<AuthSession> signUp(Credentials credentials) async {
    try {
      final data = await api.signUp(
        email: credentials.email,
        password: credentials.password,
      );
      // Use the generated fromJson factory
      final session = AuthSession.fromJson(data);
      await storage.saveSession(session);
      return session;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw const UnknownAuthError();
    }
  }

  @override
  Future<AuthSession> signIn(Credentials credentials) async {
    try {
      final data = await api.signIn(
        email: credentials.email,
        password: credentials.password,
      );
      // Use the generated fromJson factory
      final session = AuthSession.fromJson(data);
      await storage.saveSession(session);
      return session;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw const UnknownAuthError();
    }
  }

  @override
  Future<void> signOut() async {
    await storage.clearSession();
  }

  @override
  Future<AuthSession> refresh() async {
    final existing = await storage.readSession();
    if (existing == null) throw const UnknownAuthError('No session to refresh');
    try {
      final data = await api.refresh(refreshToken: existing.refreshToken);

      // The refresh API returns different keys (snake_case), so we transform them
      // to match what AuthSession.fromJson expects.
      final transformedData = {
        'idToken': data['id_token'],
        'refreshToken': data['refresh_token'],
        'expiresIn': data['expires_in'],
        'localId': data['user_id'],
      };

      final session = AuthSession.fromJson(transformedData);
      await storage.saveSession(session);
      return session;
    } on AuthException {
      rethrow;
    } catch (e) {
      throw const UnknownAuthError();
    }
  }
}
