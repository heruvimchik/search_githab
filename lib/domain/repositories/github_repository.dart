import 'package:search_githab/domain/api_client/github_client.dart';
import 'package:search_githab/domain/entity/user.dart';

class GithubRepository {
  final GithubClient _githubClient;

  GithubRepository({required GithubClient githubClient})
      : _githubClient = githubClient;

  Future<List<User>> getUsers(String username) async {
    final users = await _githubClient.searchUsers(username);

    return users;
  }
}
