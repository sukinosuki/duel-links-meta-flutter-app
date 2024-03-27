// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TierList_PowerRanking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TierList_PowerRanking _$TierList_PowerRankingFromJson(
        Map<String, dynamic> json) =>
    TierList_PowerRanking()
      ..name = json['name'] as String
      ..rush = json['rush'] as bool?
      ..tournamentPower = (json['tournamentPower'] as num).toDouble()
      ..tournamentPowerTrend = json['tournamentPowerTrend'] as String
      ..oid = json['_id'] as String;

Map<String, dynamic> _$TierList_PowerRankingToJson(
        TierList_PowerRanking instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rush': instance.rush,
      'tournamentPower': instance.tournamentPower,
      'tournamentPowerTrend': instance.tournamentPowerTrend,
      '_id': instance.oid,
    };
