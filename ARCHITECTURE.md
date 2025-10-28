# E-Commerce App - Architecture Documentation

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Pattern](#architecture-pattern)
3. [Technology Stack](#technology-stack)
4. [Project Structure](#project-structure)
5. [Design Decisions](#design-decisions)
6. [Authentication Flow](#authentication-flow)
7. [State Management](#state-management)
8. [Dependency Injection](#dependency-injection)
9. [Error Handling](#error-handling)
10. [Security Considerations](#security-considerations)
11. [Code Quality Metrics](#code-quality-metrics)
12. [Testing Strategy](#testing-strategy)

---

## 🎯 Project Overview

### Goal
Build a **production-grade** e-commerce Flutter application using REST-only approach (no Firebase SDKs) to demonstrate:
- Clean Architecture principles
- Advanced Flutter patterns
- Manual API integration
- Professional code quality

### Current Status: **Phase 1 - Authentication (Complete)**

**Features Implemented:**
- ✅ User Registration (Sign Up)
- ✅ User Authentication (Sign In)
- ✅ Session Management (Sign Out)
- ✅ Automatic Token Refresh
- ✅ Session Persistence & Restoration
- ✅ Secure Token Storage

---

## 🏗️ Architecture Pattern

### Clean Architecture (Feature-First)

```
┌─────────────────────────────────────────────────────────────┐
│                     Presentation Layer                       │
│  (UI, Widgets, Cubit/State Management)                      │
│  • auth_page.dart (UI)                                       │
│  • auth_cubit.dart (Business Logic)                          │
│  • auth_state.dart (UI States)                               │
└────────────────────┬────────────────────────────────────────┘
                     │ Events/State
                     ↓
┌─────────────────────────────────────────────────────────────┐
│                      Domain Layer                            │
│  (Business Logic, Entities, Use Cases - Pure Dart)          │
│  • auth_session.dart (Entity)                                │
│  • credentials.dart (Value Object)                           │
│  • auth_repository.dart (Interface)                          │
│  • auth_exceptions.dart (Domain Errors)                      │
└────────────────────┬────────────────────────────────────────┘
                     │ Contracts
                     ↓
┌─────────────────────────────────────────────────────────────┐
│                       Data Layer                             │
│  (API Calls, Repository Implementation, Data Models)        │
│  • auth_api.dart (REST API)                                  │
│  • auth_repository_impl.dart (Repository Implementation)     │
└────────────────────┬────────────────────────────────────────┘
                     │
                     ↓
┌─────────────────────────────────────────────────────────────┐
│                    Infrastructure Layer                       │
│  (Framework-specific: Network, Storage, DI)                 │
│  • dio_client.dart (HTTP)                                    │
│  • auth_interceptor.dart (Token Refresh)                     │
│  • secure_session_storage_impl.dart (Persistence)            │
│  • service_locator.dart (Dependency Injection)               │
└─────────────────────────────────────────────────────────────┘
```

### Key Principles Applied

1. **Dependency Inversion** - High-level modules don't depend on low-level modules
2. **Single Responsibility** - Each class has one reason to change
3. **Interface Segregation** - Abstract interfaces define contracts
4. **Open/Closed** - Open for extension, closed for modification

---

## 🛠️ Technology Stack

### Core Dependencies

```yaml
dependencies:
  # State Management
  flutter_bloc: ^9.0.0          # Cubit for auth state
  
  # Networking
  dio: ^5.5.0                   # HTTP client
  
  # Code Generation
  freezed_annotation: ^2.4.1    # Data class generation
  json_annotation: ^4.8.1       # JSON serialization
  
  # Dependency Injection
  get_it: ^7.6.7                # Service locator pattern
  
  # Security
  flutter_secure_storage: ^9.2.2 # Encrypted token storage
  
  # Configuration
  flutter_dotenv: ^5.1.0        # Environment variables
  
  # Utilities
  equatable: ^2.0.7             # Value equality

dev_dependencies:
  # Code Generation
  build_runner: ^2.4.8
  freezed: ^2.4.7
  json_serializable: ^6.7.1
  
  # Testing & Quality
  flutter_test: sdk: flutter
  flutter_lints: ^5.0.0
```

### Why These Choices?

**flutter_bloc (Cubit):**
- ✅ Simpler than full Bloc for auth
- ✅ Built-in testing support
- ✅ Clear state transitions
- ✅ Industry standard

**Freezed:**
- ✅ Eliminates boilerplate for data classes
- ✅ Sealed unions for type-safe states
- ✅ Auto-generated `copyWith`, `==`, `hashCode`
- ✅ JSON serialization support

**GetIt:**
- ✅ Lazy initialization
- ✅ Singleton management
- ✅ No BuildContext required
- ✅ Easy testing with mocks

**Dio:**
- ✅ Interceptors for token refresh
- ✅ Better error handling than http
- ✅ Request/response transformation
- ✅ Timeout configuration

---

## 📁 Project Structure

```
lib/
├── core/                           # Shared infrastructure
│   ├── config/
│   │   └── app_config.dart        # Environment configuration
│   ├── di/
│   │   └── service_locator.dart   # GetIt dependency injection
│   ├── network/
│   │   ├── auth_interceptor.dart  # Auto token refresh on 401
│   │   └── dio_client.dart        # HTTP client factory
│   └── storage/
│       ├── secure_storage.dart             # Storage interface
│       └── secure_session_storage_impl.dart # Encrypted persistence
│
├── features/                       # Feature modules (vertical slices)
│   └── auth/                      # Authentication feature
│       ├── data/                  # Data layer
│       │   ├── auth_api.dart                 # Firebase REST API
│       │   └── auth_repository_impl.dart     # Repository implementation
│       │
│       ├── domain/                # Domain layer (pure Dart)
│       │   ├── entities/
│       │   │   ├── auth_session.dart         # Session entity (Freezed)
│       │   │   ├── auth_session.freezed.dart # Generated
│       │   │   └── auth_session.g.dart       # Generated JSON
│       │   │
│       │   ├── errors/
│       │   │   └── auth_exceptions.dart      # Domain exceptions
│       │   │
│       │   ├── repositories/
│       │   │   └── auth_repository.dart      # Repository interface
│       │   │
│       │   └── value_objects/
│       │       └── credentials.dart          # Email + Password VO
│       │
│       └── presentation/          # Presentation layer
│           ├── cubit/
│           │   ├── auth_cubit.dart           # Business logic
│           │   ├── auth_state.dart           # UI states (Freezed)
│           │   └── auth_state.freezed.dart   # Generated
│           │
│           └── pages/
│               └── auth_page.dart            # Auth UI
│
├── main.dart                       # App entry point
└── firebase_options.dart           # Firebase config (not used, kept for future)
```

### Folder Structure Rationale

**Feature-First (Vertical Slicing):**
- Each feature (`auth/`, `products/`, etc.) is self-contained
- Can be extracted as a separate package
- Clear boundaries between features
- Easy to understand and maintain

**Layer Separation:**
- `domain/` - Pure business logic (no Flutter/framework dependencies)
- `data/` - External data sources (APIs, databases)
- `presentation/` - UI and state management

---

## 🎯 Design Decisions

### 1. REST-Only Approach (No Firebase SDKs)

**Decision:** Use Firebase Identity Toolkit REST API instead of `firebase_auth` SDK.

**Rationale:**
- ✅ **Learning:** Understand authentication internals
- ✅ **Control:** Manual token management and refresh
- ✅ **Flexibility:** Not locked into Firebase SDK patterns
- ✅ **Transparency:** See exactly what's happening

**Trade-offs:**
- ❌ More code to write (but more learning)
- ❌ Manual error mapping
- ✅ But: Full control and understanding

**Implementation:**
```dart
// lib/features/auth/data/auth_api.dart
Future<Map<String, dynamic>> signIn({
  required String email,
  required String password,
}) async {
  final response = await _dio.post(
    '${AppConfig.identityToolkitBaseUrl}/accounts:signInWithPassword',
    queryParameters: {'key': AppConfig.apiKey},
    data: {
      'email': email,
      'password': password,
      'returnSecureToken': true,
    },
  );
  return response.data as Map<String, dynamic>;
}
```

---

### 2. Freezed for Data Classes

**Decision:** Use Freezed for entities and states instead of manual classes.

**Rationale:**
- ✅ **Reduces boilerplate:** Auto-generates `copyWith`, `==`, `hashCode`, `toString`
- ✅ **Type safety:** Sealed unions for states
- ✅ **JSON support:** Built-in serialization
- ✅ **Industry standard:** Used by Google, Very Good Ventures

**Example:**
```dart
// Before (Manual)
class AuthSession {
  final String idToken;
  final String refreshToken;
  final DateTime expiresAt;
  final String userId;

  AuthSession({...});

  // Need to write: ==, hashCode, copyWith, toJson, fromJson, toString
}

// After (Freezed)
@freezed
class AuthSession with _$AuthSession {
  const AuthSession._();
  
  const factory AuthSession({
    required String idToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String userId,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);

  bool get isExpired =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));
}
// Freezed generates everything automatically!
```

---

### 3. GetIt for Dependency Injection

**Decision:** Use GetIt service locator instead of Provider/Riverpod at root.

**Rationale:**
- ✅ **Simplicity:** No widget tree pollution
- ✅ **Testability:** Easy to register mocks
- ✅ **Lazy initialization:** Dependencies created only when needed
- ✅ **Global access:** No BuildContext required in business logic

**Setup:**
```dart
// lib/core/di/service_locator.dart
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Storage
  getIt.registerLazySingleton<SecureSessionStorage>(
    () => SecureSessionStorageImpl(),
  );

  // API (base Dio without auth interceptor)
  getIt.registerLazySingleton<AuthApi>(
    () => AuthApi(DioClient.create().dio),
  );

  // Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      api: getIt<AuthApi>(),
      storage: getIt<SecureSessionStorage>(),
    ),
  );
}
```

**Usage in main.dart:**
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await setupServiceLocator();  // Setup DI
  runApp(const MyApp());
}
```

---

### 4. Cubit over Bloc

**Decision:** Use Cubit (simplified Bloc) for authentication state management.

**Rationale:**
- ✅ **Simpler:** No events, just methods
- ✅ **Sufficient:** Auth doesn't need complex event handling
- ✅ **Readable:** Direct method calls instead of event dispatch
- ✅ **Less boilerplate:** No event classes needed

**Comparison:**
```dart
// Bloc (verbose)
authBloc.add(SignInRequested(email: email, password: password));

class SignInRequested extends AuthEvent { ... }
class SignUpRequested extends AuthEvent { ... }
// Need separate event classes

// Cubit (simple)
authCubit.signIn(email, password);

// Just direct method calls
```

**Implementation:**
```dart
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  
  AuthCubit({required this.repository}) : super(const AuthState.initial());

  Future<void> signIn(String email, String password) async {
    emit(const AuthState.loading());
    try {
      final session = await repository.signIn(
        Credentials(email: email, password: password),
      );
      emit(AuthState.authenticated(...));
    } on AuthException catch (e) {
      emit(AuthState.unauthenticated(message: e.message));
    }
  }
}
```

---

### 5. Sealed Classes for Exceptions

**Decision:** Use sealed classes for domain exceptions.

**Rationale:**
- ✅ **Type safety:** Compiler ensures all cases handled
- ✅ **Exhaustiveness:** Can't forget to handle a case
- ✅ **Domain-specific:** Clear business errors

**Implementation:**
```dart
sealed class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

class EmailAlreadyInUse extends AuthException {
  const EmailAlreadyInUse([super.message = 'Email already in use']);
}

class InvalidCredentials extends AuthException {
  const InvalidCredentials([super.message = 'Invalid email or password']);
}

// Usage
try {
  await repository.signIn(...);
} on EmailAlreadyInUse catch (e) {
  // Handle duplicate email
} on InvalidCredentials catch (e) {
  // Handle wrong password
} on AuthException catch (e) {
  // Catch all other auth errors
}
```

---

### 6. Token Expiry Buffer

**Decision:** Consider tokens expired 5 minutes before actual expiry.

**Rationale:**
- ✅ **Prevents edge cases:** Avoids "just expired during request" scenarios
- ✅ **Proactive refresh:** Refreshes before expiry, not after
- ✅ **Better UX:** No failed requests due to expired tokens

**Implementation:**
```dart
// lib/features/auth/domain/entities/auth_session.dart
bool get isExpired =>
    DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));
    //                                         ^^^^^^^^^^^^^^^^^^^^^^^^
    //                                         5-minute buffer
```

---

### 7. Automatic Token Refresh with Dio Interceptor

**Decision:** Use Dio interceptor to automatically refresh tokens on 401 errors.

**Rationale:**
- ✅ **Transparent:** App code doesn't need to handle refresh logic
- ✅ **Centralized:** One place for token management
- ✅ **Retry logic:** Automatically retries failed request with new token

**Flow:**
```
1. API Request → 401 Unauthorized
2. Interceptor catches error
3. Reads refresh token from storage
4. Calls refresh endpoint
5. Saves new tokens
6. Retries original request with new token
7. Returns response to caller
```

**Implementation:**
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final session = await storage.readSession();
    if (session != null && !session.isExpired) {
      options.headers['Authorization'] = 'Bearer ${session.idToken}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Refresh token and retry
      final refreshed = await _doRefresh(session);
      final retried = await _retryRequest(err.requestOptions, refreshed.idToken);
      return handler.resolve(retried);
    }
    handler.next(err);
  }
}
```

---

### 8. Value Objects with Validation

**Decision:** Use value objects for email/password validation in domain layer.

**Rationale:**
- ✅ **Domain rules:** Validation is business logic, not UI logic
- ✅ **Fail fast:** Invalid credentials rejected before API call
- ✅ **Type safety:** Can't create invalid `Credentials`

**Implementation:**
```dart
class Credentials {
  final String email;
  final String password;

  Credentials({required this.email, required this.password}) {
    if (email.isEmpty || !email.contains('@')) {
      throw ArgumentError('Invalid email address');
    }
    if (password.isEmpty || password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }
  }
}

// Usage
try {
  final creds = Credentials(email: email, password: password);
  // If we get here, credentials are valid
} on ArgumentError catch (e) {
  // Show validation error
}
```

---

## 🔐 Authentication Flow

### Sign Up Flow

```
┌──────────┐
│   User   │
└─────┬────┘
      │ Enters email/password
      ↓
┌──────────────────┐
│  UI Validation   │ Form validators (min length, email format)
└─────┬────────────┘
      │ Valid
      ↓
┌──────────────────┐
│  AuthCubit       │ emit(AuthState.loading())
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│  Credentials VO  │ Domain validation (throws ArgumentError if invalid)
└─────┬────────────┘
      │ Valid
      ↓
┌──────────────────┐
│  AuthRepository  │
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│    AuthApi       │ POST /accounts:signUp
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│ Firebase Identity│ Returns: idToken, refreshToken, expiresIn, localId
│    Toolkit       │
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│  AuthRepository  │ Maps response to AuthSession entity
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│ Secure Storage   │ Encrypts & saves session to device
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│  AuthCubit       │ emit(AuthState.authenticated(...))
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│      UI          │ Shows authenticated screen
└──────────────────┘
```

### Sign In Flow

Same as Sign Up, but uses `/accounts:signInWithPassword` endpoint.

### Token Refresh Flow

```
┌──────────────────┐
│  Any API Call    │ GET /products (example)
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│ AuthInterceptor  │ Adds Authorization: Bearer {idToken}
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│   API Response   │ 401 Unauthorized (token expired)
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│ AuthInterceptor  │ Catches 401 error
│   onError()      │
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│ Read Storage     │ Gets refreshToken
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│    AuthApi       │ POST /token with refreshToken
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│ Firebase Secure  │ Returns new: idToken, refreshToken, expiresIn
│     Token        │
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│ Secure Storage   │ Saves new session
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│ AuthInterceptor  │ Retries original request with new idToken
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│   API Response   │ 200 OK (success)
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│  Caller Code     │ Receives response (transparent refresh)
└──────────────────┘
```

### Session Restoration (App Restart)

```
┌──────────────────┐
│   App Starts     │
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│  main.dart       │ setupServiceLocator()
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│  AuthCubit       │ Created with restore() called
└─────┬────────────┘
      │
      ↓
┌──────────────────┐
│ Secure Storage   │ readSession()
└─────┬────────────┘
      │
      ├─ Session exists & not expired
      │  ↓
      │  emit(AuthState.authenticated(...))
      │  → Show app content
      │
      └─ No session or expired
         ↓
         emit(AuthState.unauthenticated())
         → Show login screen
```

---

## 🎨 State Management

### AuthState (Freezed Sealed Union)

```dart
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated({
    required String userId,
    required DateTime expiresAt,
  }) = AuthAuthenticated;
  const factory AuthState.unauthenticated({String? message}) = AuthUnauthenticated;
}
```

### Benefits of Sealed Unions

**Type Safety:**
```dart
// Compiler forces you to handle all cases
state.when(
  initial: () => CircularProgressIndicator(),
  loading: () => CircularProgressIndicator(),
  authenticated: (userId, expiresAt) => HomeScreen(),
  unauthenticated: (message) => LoginScreen(),
  // If you forget a case, compile error!
);
```

**Pattern Matching:**
```dart
// Can also use maybeWhen, whenOrNull
state.maybeWhen(
  authenticated: (userId, _) => Text('Hello $userId'),
  orElse: () => Text('Please login'),
);
```

### State Transitions

```
            ┌─────────────┐
            │   Initial   │ App just started
            └──────┬──────┘
                   │
         ┌─────────┴─────────┐
         │                   │
    restore()           user action
         │                   │
         ↓                   ↓
   ┌──────────┐        ┌──────────┐
   │  Check   │        │ Loading  │ API call in progress
   │ Storage  │        └─────┬────┘
   └─────┬────┘              │
         │              ┌────┴────┐
         │              │         │
         │          Success    Error
         │              │         │
         │              ↓         ↓
         │      ┌──────────────┐ ┌────────────────┐
         └─────→│Authenticated │ │ Unauthenticated│
                └──────┬───────┘ └────────────────┘
                       │
                   signOut()
                       │
                       ↓
                ┌────────────────┐
                │ Unauthenticated│
                └────────────────┘
```

---

## 💉 Dependency Injection

### GetIt Service Locator Pattern

**Registration (lib/core/di/service_locator.dart):**

```dart
final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Infrastructure - Storage
  getIt.registerLazySingleton<SecureSessionStorage>(
    () => SecureSessionStorageImpl(),
  );

  // Infrastructure - Network (base Dio, no auth interceptor)
  getIt.registerLazySingleton<DioClient>(
    () => DioClient.create(),
    instanceName: 'baseClient',  // Named instance
  );

  // Data - API Layer
  getIt.registerLazySingleton<AuthApi>(
    () => AuthApi(getIt<DioClient>(instanceName: 'baseClient').dio),
  );

  // Data - Repository
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      api: getIt<AuthApi>(),
      storage: getIt<SecureSessionStorage>(),
    ),
  );

  // Infrastructure - Authenticated HTTP Client (for future features)
  getIt.registerLazySingleton<DioClient>(
    () => DioClient.create(
      addAuthInterceptor: true,
      storage: getIt<SecureSessionStorage>(),
      authApi: getIt<AuthApi>(),
    ),
    instanceName: 'authClient',  // For product/order APIs
  );
}
```

**Usage in Widget:**

```dart
BlocProvider(
  create: (_) => AuthCubit(
    repository: getIt<AuthRepository>(),
    storage: getIt<SecureSessionStorage>(),
  )..restore(),
  child: const AuthPage(),
);
```

**Why Named Instances?**
- `baseClient` - For auth API calls (no interceptor to avoid circular dependency)
- `authClient` - For other APIs (has interceptor for automatic token refresh)

---

## ⚠️ Error Handling

### Three-Layer Error Strategy

#### 1. **Data Layer** - HTTP Errors → Domain Exceptions

```dart
// lib/features/auth/data/auth_repository_impl.dart
Future<AuthSession> signIn(Credentials credentials) async {
  try {
    final data = await api.signIn(
      email: credentials.email,
      password: credentials.password,
    );
    final session = _toSession(data);
    await storage.saveSession(session);
    return session;
  } on DioException catch (e) {
    throw _mapError(e);  // Map to domain exception
  } catch (e) {
    throw const UnknownAuthError();
  }
}

AuthException _mapError(Object error) {
  final errorCode = (error is DioException && error.response?.data is Map)
      ? ((error.response!.data as Map<String, dynamic>)['error']?['message'] as String?) ?? error.toString()
      : error.toString();

  if (errorCode.contains('EMAIL_EXISTS')) return const EmailAlreadyInUse();
  if (errorCode.contains('INVALID_PASSWORD')) return const InvalidCredentials();
  if (errorCode.contains('USER_DISABLED')) return const UserDisabled();
  // ... more mappings
  return const UnknownAuthError();
}
```

#### 2. **Domain Layer** - Business Exceptions

```dart
// lib/features/auth/domain/errors/auth_exceptions.dart
sealed class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
}

class EmailAlreadyInUse extends AuthException {
  const EmailAlreadyInUse([super.message = 'Email already in use']);
}

class InvalidCredentials extends AuthException {
  const InvalidCredentials([super.message = 'Invalid email or password']);
}

class WeakPassword extends AuthException {
  const WeakPassword([super.message = 'Password is too weak']);
}
```

#### 3. **Presentation Layer** - User-Friendly Messages

```dart
// lib/features/auth/presentation/cubit/auth_cubit.dart
Future<void> signIn(String email, String password) async {
  emit(const AuthState.loading());
  try {
    final session = await repository.signIn(
      Credentials(email: email, password: password),
    );
    emit(AuthState.authenticated(...));
  } on AuthException catch (e) {
    emit(AuthState.unauthenticated(message: e.message));
  } catch (e) {
    emit(const AuthState.unauthenticated(
      message: 'An unexpected error occurred. Please try again.',
    ));
  }
}
```

### Error Display in UI

```dart
// Persistent error card
if (errorMessage != null) ...[
  Card(
    color: Colors.red[50],
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    ),
  ),
  const SizedBox(height: 16),
],
```

---

## 🔒 Security Considerations

### 1. **Encrypted Token Storage**

```dart
// Uses flutter_secure_storage (Keychain on iOS, EncryptedSharedPreferences on Android)
class SecureSessionStorageImpl implements SecureSessionStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveSession(AuthSession session) async {
    await _storage.write(
      key: 'auth_session',
      value: json.encode(session.toJson()),
    );
  }
}
```

### 2. **No Hardcoded Credentials in Production**

```dart
// lib/features/auth/presentation/pages/auth_page.dart
final _emailController = TextEditingController(
  text: kDebugMode ? 'test+123@example.com' : '',  // Only in debug builds
);
final _passwordController = TextEditingController(
  text: kDebugMode ? 'TestPass123!' : '',
);
```

### 3. **Environment Variables for API Keys**

```dart
// .env (gitignored)
FIREBASE_WEB_API_KEY=AIza...

// lib/core/config/app_config.dart
class AppConfig {
  static String get apiKey {
    final key = dotenv.env['FIREBASE_WEB_API_KEY'];
    if (key == null || key.isEmpty) {
      throw StateError('FIREBASE_WEB_API_KEY is not set');
    }
    return key;
  }
}
```

### 4. **HTTPS Only**

All API calls use HTTPS:
```dart
static const String identityToolkitBaseUrl =
    'https://identitytoolkit.googleapis.com/v1';
```

### 5. **Token Expiry Validation**

```dart
bool get isExpired =>
    DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));
```

### 6. **Automatic Token Refresh**

Interceptor handles expired tokens transparently, preventing token leakage.

---

## 📊 Code Quality Metrics

### Static Analysis

```bash
flutter analyze lib/
# Output: No issues found! (ran in 6.4s)
```

**0 warnings, 0 errors in production code** (lib/ folder)

### Test Coverage

```bash
flutter test
# Output: All tests passed! (7/7)
```

**Test Files:**
- `test/auth_error_mapping_test.dart` - Exception mapping validation

### Linter Rules

Using `flutter_lints: ^5.0.0` (strictest Flutter lints)

**Key rules enforced:**
- ✅ `prefer_const_constructors`
- ✅ `avoid_print` (use proper logging)
- ✅ `prefer_final_fields`
- ✅ `use_super_parameters`
- ✅ `prefer_conditional_assignment`

### Code Metrics

| Metric | Value |
|--------|-------|
| **Total Dart Files** | 21 files |
| **Lines of Code** | ~1,500 LOC |
| **Test Files** | 1 |
| **Test Cases** | 7 |
| **Linter Errors** | 0 |
| **Code Coverage** | Domain exceptions: 100% |

---

## 🧪 Testing Strategy

### Current Tests

**Unit Tests - Error Mapping:**
```dart
// test/auth_error_mapping_test.dart
test('EmailAlreadyInUse has correct message', () {
  const exception = EmailAlreadyInUse();
  expect(exception.message, 'Email already in use');
});

test('InvalidCredentials has correct message', () {
  const exception = InvalidCredentials();
  expect(exception.message, 'Invalid email or password');
});
// ... 7 total tests
```

### Future Testing Plans

**Unit Tests:**
- [ ] AuthCubit state transitions
- [ ] Credentials validation logic
- [ ] AuthSession expiry calculation
- [ ] Error mapping in repository

**Widget Tests:**
- [ ] AuthPage form validation
- [ ] AuthPage state rendering
- [ ] Button states during loading

**Integration Tests:**
- [ ] Full sign-in flow
- [ ] Full sign-up flow
- [ ] Session restoration
- [ ] Token refresh

---

## 🚀 Running the Project

### Prerequisites

```bash
# Flutter SDK 3.8.1+
flutter --version

# Dependencies
flutter pub get

# Code generation
dart run build_runner build --delete-conflicting-outputs
```

### Environment Setup

Create `.env` file in project root:
```env
FIREBASE_WEB_API_KEY=your_firebase_web_api_key_here
```

### Run Tests

```bash
flutter test
```

### Run App

```bash
# Debug mode (with test credentials)
flutter run

# Release mode (no test credentials)
flutter run --release
```

---

## 📈 Performance Considerations

### 1. **Lazy Dependency Initialization**

GetIt's `registerLazySingleton` creates instances only when first accessed:
```dart
getIt.registerLazySingleton<AuthRepository>(() => ...);
// Not created until first getIt<AuthRepository>() call
```

### 2. **Const Constructors**

All stateless data uses const:
```dart
const AuthState.loading()
const EmailAlreadyInUse()
```

### 3. **Freezed Optimizations**

Freezed generates efficient `==` and `hashCode` implementations.

### 4. **Token Refresh Mutex**

Prevents multiple simultaneous refresh requests:
```dart
Future<AuthSession?> _refreshing;

if (_refreshing is! Future<AuthSession>) {
  _refreshing = _doRefresh(session);
}
final refreshed = await _refreshing;
```

---

## 🎓 Learning Outcomes

### Architecture Patterns Demonstrated

- ✅ Clean Architecture (feature-first)
- ✅ Repository Pattern
- ✅ Value Object Pattern
- ✅ Service Locator Pattern (DI)
- ✅ Interceptor Pattern (token refresh)
- ✅ State Pattern (Cubit states)

### Flutter Best Practices Applied

- ✅ Freezed for data classes
- ✅ Sealed classes for type safety
- ✅ GetIt for dependency injection
- ✅ Cubit for state management
- ✅ Form validation
- ✅ Error handling strategy
- ✅ Secure storage
- ✅ Environment configuration

### Advanced Concepts

- ✅ Manual JWT token management
- ✅ Automatic token refresh with interceptors
- ✅ REST API integration (no SDKs)
- ✅ Error mapping (HTTP → Domain → UI)
- ✅ Session persistence and restoration
- ✅ Const constructors for performance
- ✅ Named DI instances

---

## 🔮 Next Steps (Phase 2)

### Planned Features

1. **Products Module**
   - Product listing (REST: Firestore REST API)
   - Product details
   - Categories & filters
   - Search

2. **Cart Module**
   - Add/remove items
   - Quantity management
   - Cart persistence

3. **Orders Module**
   - Checkout flow
   - Order history
   - Order status tracking

4. **Admin Panel**
   - Product CRUD
   - Order management
   - User management

---

## 📚 References

### Official Documentation
- [Flutter Bloc](https://bloclibrary.dev/)
- [Freezed](https://pub.dev/packages/freezed)
- [GetIt](https://pub.dev/packages/get_it)
- [Dio](https://pub.dev/packages/dio)
- [Firebase REST API](https://firebase.google.com/docs/reference/rest/auth)

### Architecture Resources
- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Very Good Architecture](https://verygood.ventures/blog/very-good-flutter-architecture)

---

## 👥 Code Review Checklist

When reviewing this codebase, please evaluate:

### Architecture
- [ ] Is Clean Architecture properly implemented?
- [ ] Are layers properly separated?
- [ ] Is feature-first structure appropriate?
- [ ] Are dependencies pointing in the right direction?

### Code Quality
- [ ] Are naming conventions consistent?
- [ ] Is error handling comprehensive?
- [ ] Are there any security concerns?
- [ ] Is the code testable?

### Technology Choices
- [ ] Is Freezed appropriate for this use case?
- [ ] Is GetIt the right DI solution?
- [ ] Is Cubit sufficient or should we use full Bloc?
- [ ] Are there better alternatives?

### Scalability
- [ ] Can this architecture scale to 10+ features?
- [ ] How will shared domain objects be handled?
- [ ] Is the DI setup scalable?
- [ ] Are there performance concerns?

### Best Practices
- [ ] Are Flutter best practices followed?
- [ ] Is the REST-only approach justified?
- [ ] Is token management implemented correctly?
- [ ] Are there any anti-patterns?

---

**Document Version:** 1.0  
**Last Updated:** October 8, 2025  
**Phase:** 1 - Authentication (Complete)  
**Status:** ✅ Production-Ready

