import 'dart:io';
import 'package:dio/dio.dart';
import 'package:search_githab/domain/entity/github_login.dart';
import 'package:search_githab/domain/entity/repository.dart';
import 'package:search_githab/domain/entity/user.dart';

import 'api_client_exception.dart';
import 'secret_keys.dart';

class GithubClient {
  late final Dio _dio = Dio(
    BaseOptions(
        connectTimeout: 5000,
        baseUrl: 'https://api.github.com/',
        headers: {HttpHeaders.acceptHeader: 'application/vnd.github.v3+json'}),
  );

  GitHubLoginResponse _loginResponse =
      GitHubLoginResponse(accessToken: '', scope: '', tokenType: '');

  GithubClient();

  //final Map<String, String> _bufFollowers = {};

  Future<T> _get<T>(
    String path,
    T Function(dynamic json) parser, [
    Map<String, dynamic>? parameters,
  ]) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: parameters,
      );
      _validateResponse(response.statusCode);
      final result = parser(response.data);
      return result;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.noInternetConnection);
    } on ApiClientException {
      rethrow;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response && e.response?.statusCode == 403) {
        throw ApiClientException(ApiClientExceptionType.unauthorisedRequest);
      } else {
        throw ApiClientException(e.message);
      }
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.unknownError);
    }
  }

  Future<List<User>> searchUsers(String username) async {
    List<User> parser(dynamic json) {
      final List<dynamic> data = json['items'];

      final users = data.map((user) => User.fromJson(user)).toList();
      return users;
    }

    final result =
        await _get('search/users', parser, {'q': username, 'per_page': 1});
    return result;
  }

  Future<int> followers(String followersUrl) async {
    int parser(dynamic json) {
      final List<dynamic> followersList = json;
      return followersList.length;
    }

    final result = await _get(
      followersUrl,
      parser,
      {'per_page': 100},
    );
    return result;
  }

  Future<List<Repository>> loadRepos(String username) async {
    List<Repository> parser(dynamic json) {
      final List<dynamic> data = json;

      final repos =
          data.map((repository) => Repository.fromJson(repository)).toList();
      return repos;
    }

    final result =
        await _get('users/$username/repos', parser, {'per_page': 30});

    //print(result[0].updatedAt);

    return result;
  }

  Future<User> getUser() async {
    User parser(dynamic json) {
      final user = User.fromJson(json);
      return user;
    }

    final result = await _get('user', parser,
        {'Authorization': 'token ${_loginResponse.accessToken}'});
    return result;
  }

  Future<void> login(String code) async {
    final gitHubLoginRequest = GitHubLoginRequest(
        clientId: GitHubKeys.githubClientId,
        clientSecret: GitHubKeys.githubClientSecret,
        code: code);

    final response = await _dio.post(
        'https://github.com/login/oauth/access_token',
        queryParameters: gitHubLoginRequest.toJson());
    print(response.data);

    _loginResponse = GitHubLoginResponse.fromJson(response.data);
  }

  void _validateResponse(int? statusCode) {
    if (statusCode == 200) return;

    switch (statusCode) {
      case 304:
        throw ApiClientException(ApiClientExceptionType.notModified);
      case 403:
        throw ApiClientException(ApiClientExceptionType.unauthorisedRequest);
      case 422:
        throw ApiClientException(ApiClientExceptionType.unprocessableEntity);
      case 503:
        throw ApiClientException(ApiClientExceptionType.serviceUnavailable);
      default:
        throw ApiClientException(ApiClientExceptionType.unknownError);
    }
  }
}
