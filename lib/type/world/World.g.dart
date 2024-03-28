// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'World.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

World _$WorldFromJson(Map<String, dynamic> json) => World()
  ..bannerImage = json['bannerImage'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..release =
      json['release'] == null ? null : DateTime.parse(json['release'] as String)
  ..shortName = json['shortName'] as String? ?? ''
  ..oid = json['_id'] as String;

Map<String, dynamic> _$WorldToJson(World instance) => <String, dynamic>{
      'bannerImage': instance.bannerImage,
      'name': instance.name,
      'release': instance.release?.toIso8601String(),
      'shortName': instance.shortName,
      '_id': instance.oid,
    };
