import 'package:json_annotation/json_annotation.dart';

part 'github_login.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GitHubLoginRequest {
  String clientId;
  String clientSecret;
  String code;

  GitHubLoginRequest(
      {required this.clientId, required this.clientSecret, required this.code});

  factory GitHubLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$GitHubLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$GitHubLoginRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GitHubLoginResponse {
  String accessToken;
  String tokenType;
  String scope;

  GitHubLoginResponse(
      {required this.accessToken,
      required this.tokenType,
      required this.scope});

  factory GitHubLoginResponse.fromJson(Map<String, dynamic> json) =>
      _$GitHubLoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GitHubLoginResponseToJson(this);
}
