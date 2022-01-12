import 'dart:io';
import 'package:dio/dio.dart';
import 'package:search_githab/domain/entity/repository.dart';
import 'package:search_githab/domain/entity/user.dart';

import 'api_client_exception.dart';

class GithubClient {
  late final Dio _dio = Dio(
    BaseOptions(
        connectTimeout: 5000,
        baseUrl: 'https://api.github.com/',
        headers: {HttpHeaders.acceptHeader: 'application/vnd.github.v3+json'}),
  );

  GithubClient();

  //final Map<String, String> _bufFollowers = {};

  Future<List<UserFollowers>> searchUsers(String username) async {
    try {
      var response = await _dio.get(
        'search/users',
        queryParameters: {'q': username, 'per_page': 1},
      );
      //print(response.statusCode);
      _validateResponse(response.statusCode);

      final List<dynamic> data = response.data['items'];
      final users = data.map((user) => User.fromJson(user)).toList();

      final List<UserFollowers> userFollowers = [];
      for (User user in users) {
        response = await _dio.get(
          user.followersUrl,
          queryParameters: {'per_page': 100},
        );
        //_bufFollowers[user.login] = response.headers['etag'];
        _validateResponse(response.statusCode);
        //print(response.headers);

        final List<dynamic> followersList = response.data;
        userFollowers
            .add(UserFollowers(user: user, followers: followersList.length));
      }

      return userFollowers;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.noInternetConnection);
    } on ApiClientException {
      rethrow;
    } on DioError catch (e) {
      throw ApiClientException(e.message);
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.unknownError);
    }
  }

  Future<List<Repository>> loadRepos(String username) async {
    try {
      var response = await _dio.get(
        'users/$username/repos',
        queryParameters: {'per_page': 50},
      );

      print(response.data);
      _validateResponse(response.statusCode);

      final List<dynamic> data = response.data;

      final repositories =
          data.map((repository) => Repository.fromJson(repository)).toList();

      return repositories;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.noInternetConnection);
    } on ApiClientException {
      rethrow;
    } on DioError catch (e) {
      throw ApiClientException(e.message);
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.unknownError);
    }
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
