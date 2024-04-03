// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GenGuide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenGuide _$GenGuideFromJson(Map<String, dynamic> json) => GenGuide()
  ..oid = json['oid'] as String? ?? ''
  ..selectionBoxEnd = json['selectionBoxEnd'] == null
      ? null
      : DateTime.parse(json['selectionBoxEnd'] as String)
  ..selectionBoxStart = json['selectionBoxStart'] == null
      ? null
      : DateTime.parse(json['selectionBoxStart'] as String)
  ..halfPriceBoxes = json['halfPriceBoxes'] == null
      ? null
      : DateTime.parse(json['halfPriceBoxes'] as String)
  ..halfPriceEnd = json['halfPriceEnd'] == null
      ? null
      : DateTime.parse(json['halfPriceEnd'] as String);

Map<String, dynamic> _$GenGuideToJson(GenGuide instance) => <String, dynamic>{
      'oid': instance.oid,
      'selectionBoxEnd': instance.selectionBoxEnd?.toIso8601String(),
      'selectionBoxStart': instance.selectionBoxStart?.toIso8601String(),
      'halfPriceBoxes': instance.halfPriceBoxes?.toIso8601String(),
      'halfPriceEnd': instance.halfPriceEnd?.toIso8601String(),
    };

GenGuide_TrendingUp _$GenGuide_TrendingUpFromJson(Map<String, dynamic> json) =>
    GenGuide_TrendingUp()
      ..trend = json['trend'] as String?
      ..name = json['name'] as String? ?? '';

Map<String, dynamic> _$GenGuide_TrendingUpToJson(
        GenGuide_TrendingUp instance) =>
    <String, dynamic>{
      'trend': instance.trend,
      'name': instance.name,
    };
