// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SkillStats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillStats _$SkillStatsFromJson(Map<String, dynamic> json) => SkillStats()
  ..count = json['count'] as int? ?? 0
  ..name = json['name'] as String? ?? ''
  ..percentage = (json['percentage'] as num?)?.toDouble() ?? 0
  ..tier = json['tier'] as int?;

Map<String, dynamic> _$SkillStatsToJson(SkillStats instance) =>
    <String, dynamic>{
      'count': instance.count,
      'name': instance.name,
      'percentage': instance.percentage,
      'tier': instance.tier,
    };

SkillStats_CoverCard _$SkillStats_CoverCardFromJson(
        Map<String, dynamic> json) =>
    SkillStats_CoverCard()
      ..oid = json['_id'] as String
      ..name = json['name'] as String;

Map<String, dynamic> _$SkillStats_CoverCardToJson(
        SkillStats_CoverCard instance) =>
    <String, dynamic>{
      '_id': instance.oid,
      'name': instance.name,
    };
