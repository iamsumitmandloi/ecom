import 'package:ecom/core/logging/app_logger.dart';
import 'package:ecom/core/storage/secure_session_storage.dart';
import 'package:ecom/features/auth/domain/errors/auth_exceptions.dart';
import 'package:ecom/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecom/features/auth/domain/value_objects/credentials.dart';
import 'package:ecom/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  final SecureSessionStorage storage;

  AuthCubit({required this.repository, required this.storage})
    : super(const AuthState.initial());

  Future<void> restore() async {
    emit(const AuthState.loading());
    try {
      AppLogger.info('Attempting to restore session');
      final session = await storage.readSession();
      if (session != null && !session.isExpired) {
        AppLogger.info(
          'Session restored successfully for user: ${session.userId}',
        );
        emit(
          AuthState.authenticated(
            userId: session.userId,
            expiresAt: session.expiresAt,
          ),
        );
      } else {
        AppLogger.info('No valid session found');
        emit(const AuthState.unauthenticated());
      }
    } catch (e, stackTrace) {
      AppLogger.error('Failed to restore session', e, stackTrace);
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(const AuthState.loading());
    try {
      AppLogger.info('Sign in attempt for email: $email');
      final session = await repository.signIn(
        Credentials(email: email, password: password),
      );
      AppLogger.info('Sign in successful for user: ${session.userId}');
      emit(
        AuthState.authenticated(
          userId: session.userId,
          expiresAt: session.expiresAt,
        ),
      );
    } on AuthException catch (e, stackTrace) {
      AppLogger.warning('Sign in failed: ${e.message}', e, stackTrace);
      emit(AuthState.unauthenticated(message: e.message));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during sign in', e, stackTrace);
      emit(
        const AuthState.unauthenticated(
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  Future<void> signUp(String email, String password) async {
    emit(const AuthState.loading());
    try {
      final session = await repository.signUp(
        Credentials(email: email, password: password),
      );
      emit(
        AuthState.authenticated(
          userId: session.userId,
          expiresAt: session.expiresAt,
        ),
      );
    } on AuthException catch (e) {
      emit(AuthState.unauthenticated(message: e.message));
    } catch (e) {
      emit(
        const AuthState.unauthenticated(
          message: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  Future<void> signOut() async {
    await repository.signOut();
    await storage.clearSession();
    emit(const AuthState.unauthenticated());
  }
}
