import 'package:json_annotation/json_annotation.dart';

part 'repository.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Repository {
  final String name;
  final String? description;
  final String commitsUrl;
  final int forksCount;
  final int stargazersCount;
  final String? language;
  final String updatedAt;
  final String defaultBranch;

  Repository(
      {required this.name,
      required this.description,
      required this.commitsUrl,
      required this.forksCount,
      required this.stargazersCount,
      required this.language,
      required this.updatedAt,
      required this.defaultBranch});

  factory Repository.fromJson(Map<String, dynamic> json) =>
      _$RepositoryFromJson(json);

  Map<String, dynamic> toJson() => _$RepositoryToJson(this);
}
