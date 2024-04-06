// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NavTab.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavTab _$NavTabFromJson(Map<String, dynamic> json) => NavTab(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
    )
      ..oid = json['_id'] as String
      ..image = json['image'] as String;

Map<String, dynamic> _$NavTabToJson(NavTab instance) => <String, dynamic>{
      '_id': instance.oid,
      'image': instance.image,
      'id': instance.id,
      'title': instance.title,
    };
