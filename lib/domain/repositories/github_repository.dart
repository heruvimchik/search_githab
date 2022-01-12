import 'package:search_githab/domain/api_client/github_client.dart';
import 'package:search_githab/domain/entity/repository.dart';
import 'package:search_githab/domain/entity/user.dart';

class GithubRepository {
  final GithubClient _githubClient;

  GithubRepository({required GithubClient githubClient})
      : _githubClient = githubClient;

  Future<List<UserFollowers>> getUsers(String username) async {
    final users = await _githubClient.searchUsers(username);

    return users;
  }

  Future<List<Repository>> getRepositories(String username) async {
    final repositories = await _githubClient.loadRepos(username);

    return repositories;
  }
}
