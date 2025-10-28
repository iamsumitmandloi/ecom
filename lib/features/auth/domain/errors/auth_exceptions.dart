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

class UserDisabled extends AuthException {
  const UserDisabled([super.message = 'User account disabled']);
}

class WeakPassword extends AuthException {
  const WeakPassword([super.message = 'Password is too weak']);
}

class RateLimited extends AuthException {
  const RateLimited([super.message = 'Too many attempts. Try later']);
}

class NetworkError extends AuthException {
  const NetworkError([super.message = 'Network error']);
}

class UnknownAuthError extends AuthException {
  const UnknownAuthError([super.message = 'Unknown authentication error']);
}
