import 'package:ecom/features/auth/domain/entities/auth_session.dart';
import 'package:ecom/features/auth/domain/value_objects/credentials.dart';

abstract class AuthRepository {
  Future<AuthSession> signUp(Credentials credentials);
  Future<AuthSession> signIn(Credentials credentials);
  Future<void> signOut();
  Future<AuthSession> refresh();
}
