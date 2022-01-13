// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repository _$RepositoryFromJson(Map<String, dynamic> json) => Repository(
      name: json['name'] as String,
      description: json['description'] as String?,
      commitsUrl: json['commits_url'] as String,
      forksCount: json['forks_count'] as int,
      stargazersCount: json['stargazers_count'] as int,
      language: json['language'] as String?,
      updatedAt: json['updated_at'] as String,
      defaultBranch: json['default_branch'] as String,
    );

Map<String, dynamic> _$RepositoryToJson(Repository instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'commits_url': instance.commitsUrl,
      'forks_count': instance.forksCount,
      'stargazers_count': instance.stargazersCount,
      'language': instance.language,
      'updated_at': instance.updatedAt,
      'default_branch': instance.defaultBranch,
    };
