// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PackSet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackSet _$PackSetFromJson(Map<String, dynamic> json) => PackSet()
  ..oid = json['_id'] as String? ?? ''
  ..type = json['type'] as String? ?? ''
  ..release =
      json['release'] == null ? null : DateTime.parse(json['release'] as String)
  ..name = json['name'] as String? ?? ''
  ..bannerImage = json['bannerImage'] as String? ?? ''
  ..icon = json['icon'] == null ? null : PackSet_Icon.fromJson(json['icon']);

Map<String, dynamic> _$PackSetToJson(PackSet instance) => <String, dynamic>{
      '_id': instance.oid,
      'type': instance.type,
      'release': instance.release?.toIso8601String(),
      'name': instance.name,
      'bannerImage': instance.bannerImage,
      'icon': instance.icon,
    };

PackSet_Icon _$PackSet_IconFromJson(Map<String, dynamic> json) => PackSet_Icon()
  ..name = json['name'] as String? ?? ''
  ..oid = json['_id'] as String? ?? '';

Map<String, dynamic> _$PackSet_IconToJson(PackSet_Icon instance) =>
    <String, dynamic>{
      'name': instance.name,
      '_id': instance.oid,
    };
