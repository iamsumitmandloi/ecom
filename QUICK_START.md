# Quick Start Guide - E-Commerce Flutter App

> **For Flutter experts reviewing this project:** This is your 5-minute quick start to get the app running and understand the architecture.

---

## ⚡ 60-Second Setup

```bash
# 1. Clone & navigate
git clone <repo-url>
cd ecom

# 2. Install dependencies
flutter pub get

# 3. Generate Freezed code
dart run build_runner build --delete-conflicting-outputs

# 4. Create .env file
echo "FIREBASE_WEB_API_KEY=your_firebase_key" > .env

# 5. Run tests
flutter test
# Output: All tests passed! (7/7)

# 6. Run app
flutter run
```

---

## 📱 Test the App

### Debug Mode (Auto-filled credentials)

1. **Sign Up:**
   - Email: `test+123@example.com` (auto-filled)
   - Password: `TestPass123!` (auto-filled)
   - Tap "Sign Up"

2. **Sign In:**
   - Use same credentials
   - Tap "Sign In"

3. **Sign Out:**
   - Tap "Sign Out"
   - Confirmation dialog appears
   - Confirm sign out

4. **Restart App:**
   - Stop and restart
   - Session automatically restored
   - No need to sign in again

### Production Mode

```bash
flutter run --release
```

Credentials are NOT auto-filled (security best practice).

---

## 🏗️ Architecture in 60 Seconds

### Pattern: Clean Architecture (Feature-First)

```
lib/
├── core/              # Infrastructure (DI, Network, Storage)
└── features/auth/     # Authentication feature
    ├── data/         # API calls, Repository impl
    ├── domain/       # Business logic (pure Dart)
    └── presentation/ # UI, Cubit, States
```

### Key Technologies

- **State Management:** flutter_bloc (Cubit)
- **DI:** GetIt
- **Code Gen:** Freezed
- **HTTP:** Dio + Interceptor (auto token refresh)
- **Storage:** flutter_secure_storage

### Data Flow

```
UI → Cubit → Repository → API → Firebase REST
     ↓
   State → UI Update
```

---

## 🔍 5 Files to Review

**If you only have 15 minutes, review these:**

1. **`lib/core/di/service_locator.dart`** (47 lines)
   - GetIt dependency injection setup
   - Shows how all dependencies are wired

2. **`lib/features/auth/presentation/cubit/auth_cubit.dart`** (86 lines)
   - State management logic
   - Error handling strategy

3. **`lib/core/network/auth_interceptor.dart`** (82 lines)
   - Automatic token refresh on 401
   - Request retry logic

4. **`lib/features/auth/domain/entities/auth_session.dart`** (24 lines)
   - Freezed entity example
   - Token expiry logic (5-min buffer)

5. **`lib/features/auth/data/auth_repository_impl.dart`** (104 lines)
   - REST API integration
   - Error mapping (HTTP → Domain)

---

## 🎯 What Makes This Different?

### 1. **REST-Only (No Firebase SDKs)**

```dart
// Direct HTTP calls to Firebase Identity Toolkit
await _dio.post(
  'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword',
  queryParameters: {'key': AppConfig.apiKey},
  data: {'email': email, 'password': password, 'returnSecureToken': true},
);
```

**Why?** Full control, learning, no SDK lock-in.

---

### 2. **Freezed Data Classes**

```dart
@freezed
class AuthSession with _$AuthSession {
  const factory AuthSession({
    required String idToken,
    required String refreshToken,
    required DateTime expiresAt,
    required String userId,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);
}
```

**Why?** Zero boilerplate, sealed unions, JSON serialization.

---

### 3. **Auto Token Refresh**

```dart
// Dio Interceptor catches 401, refreshes token, retries request
@override
void onError(DioException err, ErrorInterceptorHandler handler) async {
  if (err.response?.statusCode == 401) {
    final refreshed = await _doRefresh(session);
    final retried = await _retryRequest(err.requestOptions, refreshed.idToken);
    return handler.resolve(retried);  // Caller never sees 401!
  }
}
```

**Why?** Transparent, centralized, prevents failed requests.

---

### 4. **Type-Safe States (Freezed Sealed Unions)**

```dart
state.when(
  initial: () => CircularProgressIndicator(),
  loading: () => CircularProgressIndicator(),
  authenticated: (userId, expiresAt) => HomeScreen(),
  unauthenticated: (message) => LoginScreen(),
  // Compiler forces you to handle all cases!
);
```

**Why?** Compile-time safety, exhaustive pattern matching.

---

### 5. **Three-Layer Error Handling**

```
HTTP Error (DioException)
    ↓
Data Layer (_mapError)
    ↓
Domain Exception (EmailAlreadyInUse, InvalidCredentials...)
    ↓
Cubit (catch AuthException)
    ↓
UI State (user-friendly message)
```

**Why?** Clean separation, testable, user-friendly.

---

## 📊 Quality Metrics

```bash
# Zero linter issues
flutter analyze lib/
# No issues found!

# All tests passing
flutter test
# 00:06 +7: All tests passed!

# Architecture Score
# 9.5/10 (see IMPROVEMENTS.md)
```

---

## 🔐 Security Highlights

- ✅ Encrypted token storage (Keychain/EncryptedSharedPreferences)
- ✅ No hardcoded API keys (`.env` gitignored)
- ✅ Debug-only test credentials (`kDebugMode`)
- ✅ HTTPS only
- ✅ 5-minute token expiry buffer (proactive refresh)

---

## 🎓 What You'll Learn

### Architecture Patterns
- Clean Architecture (Uncle Bob)
- Repository Pattern
- Value Object Pattern
- Service Locator (DI)
- Interceptor Pattern

### Flutter Best Practices
- Freezed for data classes
- GetIt for DI
- Cubit for state management
- Sealed classes for type safety
- Form validation (UI + domain)

### Advanced Concepts
- Manual JWT token management
- Dio interceptors
- REST API integration
- Session persistence
- Error mapping strategy

---

## 📚 Documentation

**Choose your depth:**

1. **Quick Overview (5 min):** This file
2. **Complete Guide (45 min):** [ARCHITECTURE.md](ARCHITECTURE.md)
3. **Before/After (10 min):** [IMPROVEMENTS.md](IMPROVEMENTS.md)
4. **Project README (15 min):** [README.md](README.md)
5. **Code Review Form (30 min):** [CODE_REVIEW.md](CODE_REVIEW.md)

---

## 🐛 Common Setup Issues

### "FIREBASE_WEB_API_KEY is not set"

```bash
# Create .env file
echo "FIREBASE_WEB_API_KEY=AIzaSy..." > .env
```

### "GetIt: Object not registered"

```dart
// Ensure setupServiceLocator() is called in main()
await setupServiceLocator();
```

### "Freezed files missing"

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🔍 Code Review Tips

### What to Look For

**✅ Good:**
- Clean layer separation
- Type-safe error handling
- Sealed unions for states
- Automatic token refresh
- Zero linter errors

**❓ Questions:**
- Is REST-only justified?
- GetIt vs Provider/Riverpod?
- Cubit vs full Bloc?
- Feature-specific vs shared domain?

**See [CODE_REVIEW.md](CODE_REVIEW.md) for detailed review form.**

---

## 🎯 Phase Roadmap

### ✅ Phase 1 - Authentication (COMPLETE)
- Sign up, Sign in, Sign out
- Token management & refresh
- Session persistence
- **Status:** Production-ready

### 🚧 Phase 2 - Products (NEXT)
- Product listing
- Firestore REST API
- Categories & filters
- Search

### 📅 Phase 3 - Cart & Orders
- Shopping cart
- Checkout flow
- Order management

---

## 💡 Quick Tips for Reviewers

### Run Tests First
```bash
flutter test
```
All should pass (7/7).

### Check Code Quality
```bash
flutter analyze lib/
```
Should have 0 issues.

### Explore Architecture
```bash
# Feature-first structure
ls -la lib/features/auth/

# Three layers
ls -la lib/features/auth/data/
ls -la lib/features/auth/domain/
ls -la lib/features/auth/presentation/
```

### Review Key Files
1. `lib/core/di/service_locator.dart` - DI
2. `lib/core/network/auth_interceptor.dart` - Token refresh
3. `lib/features/auth/presentation/cubit/auth_cubit.dart` - State logic

---

## 📞 Questions?

**For architecture questions:** See [ARCHITECTURE.md](ARCHITECTURE.md)  
**For code review:** Use [CODE_REVIEW.md](CODE_REVIEW.md)  
**For quick reference:** This file

---

## ⏱️ Time Estimate

- **Setup:** 5 minutes
- **Run & Test App:** 5 minutes
- **Code Review (Quick):** 15 minutes
- **Code Review (Deep):** 45 minutes
- **Full Documentation:** 60 minutes

---

**Status:** ✅ Ready for Review  
**Last Updated:** October 8, 2025  
**Version:** 1.0 (Phase 1 - Authentication)

---

**🎯 TL;DR:** 
1. Run `flutter pub get && dart run build_runner build`
2. Create `.env` with Firebase key
3. Run `flutter test` (7/7 should pass)
4. Run `flutter run`
5. Review [CODE_REVIEW.md](CODE_REVIEW.md) for feedback form

