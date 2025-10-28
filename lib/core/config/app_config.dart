import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  AppConfig._();

  static String get apiKey {
    final key = dotenv.env['FIREBASE_WEB_API_KEY'];
    if (key == null || key.isEmpty) {
      throw StateError('FIREBASE_WEB_API_KEY is not set');
    }
    return key;
  }

  static String get firebaseProjectId {
    final projectId = dotenv.env['FIREBASE_PROJECT_ID'];
    if (projectId == null || projectId.isEmpty) {
      throw StateError('FIREBASE_PROJECT_ID is not set');
    }
    return projectId;
  }

  static const String identityToolkitBaseUrl =
      'https://identitytoolkit.googleapis.com/v1';

  static const String secureTokenBaseUrl =
      'https://securetoken.googleapis.com/v1';
}
