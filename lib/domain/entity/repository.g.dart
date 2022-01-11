// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Repository _$RepositoryFromJson(Map<String, dynamic> json) => Repository(
      name: json['name'] as String,
      description: json['description'] as String,
      forksCount: json['forks_count'] as int,
      stargazersCount: json['stargazers_count'] as int,
      language: json['language'] as String?,
    );

Map<String, dynamic> _$RepositoryToJson(Repository instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'forks_count': instance.forksCount,
      'stargazers_count': instance.stargazersCount,
      'language': instance.language,
    };
