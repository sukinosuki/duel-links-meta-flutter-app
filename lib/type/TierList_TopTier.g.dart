// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TierList_TopTier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TierList_TopTier _$TierList_TopTierFromJson(Map<String, dynamic> json) =>
    TierList_TopTier(
      name: json['name'] as String,
      oid: json['_id'] as String,
      tier: json['tier'] as int,
    );

Map<String, dynamic> _$TierList_TopTierToJson(TierList_TopTier instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tier': instance.tier,
      '_id': instance.oid,
    };
