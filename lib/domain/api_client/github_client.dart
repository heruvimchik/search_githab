import 'dart:io';
import 'package:dio/dio.dart';
import 'package:search_githab/domain/entity/user.dart';

import 'api_client_exception.dart';

class GithubClient {
  late final Dio _dio = Dio(
    BaseOptions(
        baseUrl: 'https://api.github.com/',
        headers: {HttpHeaders.acceptHeader: 'application/vnd.github.v3+json'}),
  );

  GithubClient();

  Future<List<User>> searchUsers(String username) async {
    try {
      final response = await _dio.get(
        'search/users',
        queryParameters: {'q': username},
      );
      //print(response.statusCode);
      _validateResponse(response.statusCode);

      final List<dynamic> data = response.data['items'];
      final users = data.map((user) => User.fromJson(user)).toList();
      return users;
    } on SocketException {
      throw ApiClientException(ApiClientExceptionType.noInternetConnection);
    } on ApiClientException {
      rethrow;
    } catch (e) {
      throw ApiClientException(ApiClientExceptionType.unknownError);
    }
  }

  void _validateResponse(int? statusCode) {
    switch (statusCode) {
      case 304:
        throw ApiClientException(ApiClientExceptionType.notModified);
      case 422:
        throw ApiClientException(ApiClientExceptionType.unprocessableEntity);
      case 503:
        throw ApiClientException(ApiClientExceptionType.serviceUnavailable);
      case null:
        throw ApiClientException(ApiClientExceptionType.unknownError);
    }
  }
}
