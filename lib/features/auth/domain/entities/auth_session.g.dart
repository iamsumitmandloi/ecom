// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthSessionImpl _$$AuthSessionImplFromJson(Map<String, dynamic> json) =>
    _$AuthSessionImpl(
      idToken: json['idToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: _expiresInToDateTime(json['expiresIn'] as String),
      userId: json['localId'] as String,
    );

Map<String, dynamic> _$$AuthSessionImplToJson(_$AuthSessionImpl instance) =>
    <String, dynamic>{
      'idToken': instance.idToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresAt.toIso8601String(),
      'localId': instance.userId,
    };
