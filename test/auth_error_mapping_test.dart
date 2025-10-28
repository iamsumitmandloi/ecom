import 'package:ecom/features/auth/domain/errors/auth_exceptions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Auth error mapping', () {
    test('EmailAlreadyInUse has correct message', () {
      const exception = EmailAlreadyInUse();
      expect(exception.message, 'Email already in use');
    });

    test('InvalidCredentials has correct message', () {
      const exception = InvalidCredentials();
      expect(exception.message, 'Invalid email or password');
    });

    test('UserDisabled has correct message', () {
      const exception = UserDisabled();
      expect(exception.message, 'User account disabled');
    });

    test('WeakPassword has correct message', () {
      const exception = WeakPassword();
      expect(exception.message, 'Password is too weak');
    });

    test('RateLimited has correct message', () {
      const exception = RateLimited();
      expect(exception.message, 'Too many attempts. Try later');
    });

    test('NetworkError has correct message', () {
      const exception = NetworkError();
      expect(exception.message, 'Network error');
    });

    test('UnknownAuthError has correct message', () {
      const exception = UnknownAuthError();
      expect(exception.message, 'Unknown authentication error');
    });
  });
}
