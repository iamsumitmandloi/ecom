# TODO: Deferred Improvements

> **Items to implement in future phases** based on expert feedback analysis.
> See `EXPERT_FEEDBACK_ANALYSIS.md` for full details on each item.

---

## 🚧 **Priority 2: Implement During Phase 2 (Products)**

### 1. **Mock Generation for Testing** ⭐⭐
**When:** Before starting Phase 2  
**Estimated Time:** 1 hour

```yaml
# pubspec.yaml
dev_dependencies:
  mockito: ^5.4.4
  build_runner: ^2.4.8
```

**Steps:**
1. Add mockito to dev_dependencies
2. Create `test/helpers/mocks.dart` with `@GenerateMocks` annotations
3. Run `dart run build_runner build`
4. Write unit tests for AuthCubit
5. Write unit tests for AuthRepositoryImpl

**Benefits:**
- Test auth flows without real API calls
- Test error scenarios easily
- Faster test execution

---

### 2. **Integration Tests** ⭐⭐
**When:** After Phase 2 features complete  
**Estimated Time:** 2 hours

```yaml
# pubspec.yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

**Steps:**
1. Create `integration_test/` folder
2. Write `auth_flow_test.dart` (full sign-in/sign-up/sign-out)
3. Write `session_restoration_test.dart`
4. Run: `flutter test integration_test/`

**Benefits:**
- Tests real user flows
- Catches integration issues
- Confidence before releases

---

### 3. **Shimmer Loading States** ⭐
**When:** Phase 2 (Product Listing)  
**Estimated Time:** 30 minutes

```yaml
# pubspec.yaml
shimmer: ^3.0.0
```

**Usage:**
```dart
// For product loading skeleton
ShimmerLoading(
  child: ListView.builder(
    itemCount: 10,
    itemBuilder: (context, index) => ProductCardSkeleton(),
  ),
)
```

**Benefits:**
- Better perceived performance
- Modern UX pattern
- Users know content is loading

---

### 4. **Cached Network Images** ⭐⭐
**When:** Phase 2 (Product Images)  
**Estimated Time:** 20 minutes  
**Priority:** HIGH for Phase 2

```yaml
# pubspec.yaml
cached_network_image: ^3.3.1
```

**Create Wrapper:**
```dart
// lib/core/widgets/cached_image.dart
class CachedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      memCacheWidth: width?.toInt(),
      maxWidthDiskCache: width?.toInt(),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
```

**Benefits:**
- Essential for product images
- Reduces bandwidth usage
- Better scrolling performance

---

### 5. **Golden Tests for UI** ⭐
**When:** After UI is polished (end of Phase 2)  
**Estimated Time:** 1 hour

**Steps:**
1. Create `test/features/auth/presentation/pages/auth_page_golden_test.dart`
2. Write golden tests for each auth state (unauthenticated, loading, authenticated, error)
3. Generate goldens: `flutter test --update-goldens`
4. Commit golden files to git

**Benefits:**
- Visual regression testing
- Catches UI breaks automatically
- Professional testing approach

---

## 📅 **Priority 3: Future / Optional**

### 6. **Use Cases Layer** 🤔
**When:** Phase 3+ (when business logic becomes complex)  
**Estimated Time:** 3 hours  
**Only if:** You add complex business rules (e.g., multi-factor auth, role-based access)

**Example:**
```dart
// lib/features/auth/domain/usecases/sign_in_use_case.dart
class SignInUseCase {
  final AuthRepository repository;
  final AnalyticsService analytics; // Example: additional logic
  
  Future<AuthSession> execute(Credentials credentials) async {
    await analytics.logSignInAttempt();
    final session = await repository.signIn(credentials);
    await analytics.logSignInSuccess();
    return session;
  }
}
```

**Current Verdict:** **NOT NEEDED**  
**Reason:** Auth logic is simple, Cubit handles it well

---

### 7. **Mapper Pattern** 🤔
**When:** Phase 3+ (when API responses become complex)  
**Estimated Time:** 2 hours  
**Only if:** Supporting multiple backends or complex JSON transformations

**Example:**
```dart
// lib/features/auth/data/mappers/auth_session_mapper.dart
class AuthSessionMapper {
  static AuthSession fromFirebaseJson(Map<String, dynamic> json) { ... }
  static AuthSession fromCustomBackendJson(Map<String, dynamic> json) { ... }
}
```

**Current Verdict:** **NOT NEEDED**  
**Reason:** Freezed handles JSON serialization, Firebase response is simple

---

### 8. **Biometric Authentication** 🔐
**When:** Phase 4+ (after core features work)  
**Estimated Time:** 2 hours

```yaml
# pubspec.yaml
local_auth: ^2.2.0
```

**Implementation:**
```dart
// Quick sign-in with Face ID/Touch ID
final authenticated = await localAuth.authenticate(
  localizedReason: 'Sign in with biometrics',
);
if (authenticated) {
  // Restore session from secure storage
}
```

**Benefits:**
- Better UX for returning users
- Increased security
- Modern mobile pattern

---

### 9. **Firebase Analytics (SDK)** 📊
**When:** Phase 4+ (when you need real analytics)  
**Estimated Time:** 1 hour

```yaml
# pubspec.yaml
firebase_analytics: ^11.0.0
```

**Why SDK instead of REST:**
- Easier to use than Measurement Protocol
- Automatic screen tracking
- Better debugging tools

**Deferred because:**
- Not needed for learning project
- REST approach demonstrates API skills
- Add when you have real users

---

### 10. **App Localization** 🌍
**When:** Phase 5+ (internationalization)  
**Estimated Time:** 4 hours

```yaml
# pubspec.yaml
flutter_localizations:
  sdk: flutter
intl: ^0.19.0
```

**Benefits:**
- Support multiple languages
- Reach international markets

**Deferred because:**
- Single language sufficient for MVP
- Complex setup
- Add when targeting specific markets

---

### 11. **State Restoration** 📱
**When:** Phase 4+ (complex navigation)  
**Estimated Time:** 2 hours

**Implementation:**
- Use Flutter's `RestorationMixin`
- Restore navigation stack on app restart
- iOS App Store requirement

**Deferred because:**
- Auth session restoration is enough
- Add when multi-screen navigation is complex
- Not required for Android

---

### 12. **CI/CD Pipeline** 🚀
**When:** Before production release  
**Estimated Time:** 4 hours

**Setup:**
- GitHub Actions for PR checks
- Automatic test runs
- Build APK/IPA on merge to main
- Deploy to TestFlight/Play Console

**Example workflow:**
```yaml
# .github/workflows/ci.yml
name: CI
on: [pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```

**Deferred because:**
- Not needed for solo learning project
- Add when preparing for production
- Good to have, but not blocking

---

## 📋 **Implementation Checklist**

### **Before Phase 2 Starts:**
- [ ] Add mockito and write AuthCubit tests (1 hour)

### **During Phase 2 (Products):**
- [ ] Add cached_network_image for product images (20 min)
- [ ] Add shimmer for loading states (30 min)
- [ ] Write integration tests for auth + products (2 hours)
- [ ] Add golden tests for polished UI (1 hour)

### **Phase 3+ (As Needed):**
- [ ] Biometric auth (if UX improvement needed)
- [ ] Use Cases (if business logic becomes complex)
- [ ] Mapper pattern (if supporting multiple backends)

### **Pre-Production:**
- [ ] Firebase Analytics SDK (when ready for users)
- [ ] Localization (if going international)
- [ ] CI/CD pipeline (for team/release automation)
- [ ] State restoration (for iOS App Store)

---

## 🎯 **Decision Matrix**

| Feature | Complexity | Benefit | Add in Phase |
|---------|-----------|---------|--------------|
| **Mockito tests** | Low | High | Before Phase 2 |
| **Integration tests** | Medium | High | Phase 2 |
| **Cached images** | Low | High | Phase 2 (products) |
| **Shimmer** | Low | Medium | Phase 2 (lists) |
| **Golden tests** | Low | Medium | End of Phase 2 |
| **Biometric** | Medium | Medium | Phase 4+ |
| **Use Cases** | High | Low* | Only if needed |
| **Mappers** | Medium | Low* | Only if needed |
| **Analytics** | Low | Medium | Phase 4+ |
| **Localization** | High | Low* | Phase 5+ |
| **State restoration** | Medium | Low* | iOS release |
| **CI/CD** | High | High* | Pre-production |

*Low benefit now, high benefit at scale

---

## 💡 **Remember**

**YAGNI Principle:** "You Aren't Gonna Need It"

- ✅ Add features when you actually need them
- ✅ Start simple, add complexity when justified
- ❌ Don't over-engineer prematurely

**Current Status:**
- ✅ Phase 1 (Auth): Production-ready with logging, network resilience, retry logic
- 🚧 Phase 2 (Products): Ready to start with solid foundation
- 📅 Phase 3+: Enhancements available when needed

---

**Last Updated:** October 8, 2025  
**Status:** Foundation complete, ready for feature development

