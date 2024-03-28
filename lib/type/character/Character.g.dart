// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character()
  ..oid = json['_id'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..victoryImage = json['victoryImage'] as String? ?? ''
  ..thumbnailImage = json['thumbnailImage'] as String? ?? ''
  ..worlds = (json['worlds'] as List<dynamic>?)
          ?.map(Character_World.fromJson)
          .toList() ??
      [];

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      '_id': instance.oid,
      'name': instance.name,
      'victoryImage': instance.victoryImage,
      'thumbnailImage': instance.thumbnailImage,
      'worlds': instance.worlds,
    };

Character_LinkedArticle _$Character_LinkedArticleFromJson(
        Map<String, dynamic> json) =>
    Character_LinkedArticle()
      ..description = json['description'] as String? ?? ''
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String)
      ..category = json['category'] as String? ?? ''
      ..title = json['title'] as String? ?? ''
      ..image = json['image'] as String? ?? '';

Map<String, dynamic> _$Character_LinkedArticleToJson(
        Character_LinkedArticle instance) =>
    <String, dynamic>{
      'description': instance.description,
      'date': instance.date?.toIso8601String(),
      'category': instance.category,
      'title': instance.title,
      'image': instance.image,
    };

Character_World _$Character_WorldFromJson(Map<String, dynamic> json) =>
    Character_World()
      ..name = json['name'] as String? ?? ''
      ..shortName = json['shortName'] as String? ?? ''
      ..oid = json['_id'] as String? ?? '';

Map<String, dynamic> _$Character_WorldToJson(Character_World instance) =>
    <String, dynamic>{
      'name': instance.name,
      'shortName': instance.shortName,
      '_id': instance.oid,
    };
