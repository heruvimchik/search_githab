// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github_login.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GitHubLoginRequest _$GitHubLoginRequestFromJson(Map<String, dynamic> json) =>
    GitHubLoginRequest(
      clientId: json['client_id'] as String,
      clientSecret: json['client_secret'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$GitHubLoginRequestToJson(GitHubLoginRequest instance) =>
    <String, dynamic>{
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
      'code': instance.code,
    };

GitHubLoginResponse _$GitHubLoginResponseFromJson(Map<String, dynamic> json) =>
    GitHubLoginResponse(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      scope: json['scope'] as String,
    );

Map<String, dynamic> _$GitHubLoginResponseToJson(
        GitHubLoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'scope': instance.scope,
    };
