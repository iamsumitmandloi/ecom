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
