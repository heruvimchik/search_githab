import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class User {
  final String login;
  final String? name;
  final String avatarUrl;
  final String followersUrl;
  final String? email;
  final int? publicRepos;
  final int? publicGists;
  final int? followers;
  final int? following;
  User({
    required this.login,
    required this.name,
    required this.avatarUrl,
    required this.followersUrl,
    required this.email,
    required this.publicRepos,
    required this.publicGists,
    required this.followers,
    required this.following,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class UserFollowers {
  final User user;
  final int followers;

  UserFollowers({
    required this.user,
    required this.followers,
  });
}
