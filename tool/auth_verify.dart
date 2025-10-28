import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ecom/core/network/dio_client.dart';
import 'package:ecom/core/storage/secure_session_storage.dart';
import 'package:ecom/features/auth/domain/entities/auth_session.dart';
import 'package:ecom/features/auth/domain/value_objects/credentials.dart';

// Simple in-memory storage for verification run (no secure storage needed here)
class InMemorySessionStorage implements SecureSessionStorage {
  AuthSession? _session;
  @override
  Future<void> clearSession() async {
    _session = null;
  }

  @override
  Future<AuthSession?> readSession() async {
    return _session;
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    _session = session;
  }
}

Future<void> main(List<String> args) async {
  String? email;
  String? password;

  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--email' && i + 1 < args.length) email = args[i + 1];
    if (args[i] == '--password' && i + 1 < args.length) password = args[i + 1];
  }

  email ??= Platform.environment['AUTH_EMAIL'];
  password ??= Platform.environment['AUTH_PASSWORD'];

  if (email == null || password == null) {
    stderr.writeln(
      'Usage: dart run tool/auth_verify.dart --email you@example.com --password yourpassword',
    );
    stderr.writeln(
      'Or set AUTH_EMAIL and AUTH_PASSWORD environment variables.',
    );
    exit(64);
  }

  final dio = DioClient.create().dio;
  // Optional basic logging for visibility
  dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));

  final apiKey =
      Platform.environment['FIREBASE_WEB_API_KEY'] ?? _readApiKeyFromEnvFile();
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln(
      'FIREBASE_WEB_API_KEY not set. Put it in .env or export it.',
    );
    exit(64);
  }

  final repo = _InlineRepo(
    dio: dio,
    apiKey: apiKey,
    storage: InMemorySessionStorage(),
  );

  stdout.writeln('Verifying REST auth with email: $email');

  try {
    // Try sign-up first; if the email exists, fall back to sign-in
    final signedUp = await repo.signUp(
      Credentials(email: email!, password: password!),
    );
    stdout.writeln(
      'Sign-up OK. userId=${signedUp.userId}, expiresAt=${signedUp.expiresAt.toIso8601String()}',
    );
  } catch (e) {
    final msg = e.toString();
    if (msg.contains('EMAIL_EXISTS')) {
      stdout.writeln('Email exists. Attempting sign-in...');
    } else {
      stdout.writeln('Sign-up failed: $msg');
      rethrow;
    }
  }

  // Final sign-in to confirm flow
  final session = await repo.signIn(
    Credentials(email: email!, password: password!),
  );
  stdout.writeln('Final sign-in OK. idToken length=${session.idToken.length}');
  stdout.writeln('All good.');
}

String? _readApiKeyFromEnvFile() {
  try {
    final file = File('.env');
    if (!file.existsSync()) return null;
    for (final line in file.readAsLinesSync()) {
      final trimmed = line.trim();
      if (trimmed.startsWith('FIREBASE_WEB_API_KEY=')) {
        final idx = trimmed.indexOf('=');
        if (idx != -1 && idx + 1 < trimmed.length) {
          return trimmed.substring(idx + 1);
        }
      }
    }
  } catch (_) {}
  return null;
}

class _InlineRepo {
  final Dio dio;
  final String apiKey;
  final SecureSessionStorage storage;

  _InlineRepo({required this.dio, required this.apiKey, required this.storage});

  static const String _identityBase =
      'https://identitytoolkit.googleapis.com/v1';

  Future<AuthSession> signIn(Credentials credentials) async {
    final resp = await dio.post(
      '$_identityBase/accounts:signInWithPassword',
      queryParameters: {'key': apiKey},
      data: {
        'email': credentials.email,
        'password': credentials.password,
        'returnSecureToken': true,
      },
    );
    final json = resp.data as Map<String, dynamic>;
    final session = _toSession(json);
    await storage.saveSession(session);
    return session;
  }

  Future<AuthSession> signUp(Credentials credentials) async {
    final resp = await dio.post(
      '$_identityBase/accounts:signUp',
      queryParameters: {'key': apiKey},
      data: {
        'email': credentials.email,
        'password': credentials.password,
        'returnSecureToken': true,
      },
    );
    final json = resp.data as Map<String, dynamic>;
    final session = _toSession(json);
    await storage.saveSession(session);
    return session;
  }

  AuthSession _toSession(Map<String, dynamic> json) {
    final expiresIn =
        int.tryParse(json['expiresIn']?.toString() ?? '3600') ?? 3600;
    return AuthSession(
      idToken: json['idToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: DateTime.now().add(Duration(seconds: expiresIn)),
      userId: json['localId'] as String,
    );
  }
}
