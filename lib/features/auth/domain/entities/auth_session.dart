import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';
part 'auth_session.g.dart';

/// Converts the `expiresIn` (a String of seconds) from the API to a [DateTime].
DateTime _expiresInToDateTime(String expiresIn) {
  final seconds = int.tryParse(expiresIn) ?? 3600;
  return DateTime.now().add(Duration(seconds: seconds));
}

@freezed
class AuthSession with _$AuthSession {
  const AuthSession._();

  const factory AuthSession({
    @JsonKey(name: 'idToken') required String idToken,
    @JsonKey(name: 'refreshToken') required String refreshToken,
    @JsonKey(name: 'expiresIn', fromJson: _expiresInToDateTime)
    required DateTime expiresAt,
    @JsonKey(name: 'localId') required String userId,
  }) = _AuthSession;

  factory AuthSession.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionFromJson(json);

  /// Checks if the token is expired, with a 5-minute buffer.
  bool get isExpired =>
      DateTime.now().isAfter(expiresAt.subtract(const Duration(minutes: 5)));
}
