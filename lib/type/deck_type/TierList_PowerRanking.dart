import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TierList_PowerRanking.g.dart';

@JsonSerializable(includeIfNull: true)
@HiveType(typeId: MyHive.tier_list_power_ranking)
class TierList_PowerRanking {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  bool? rush = false;

  @HiveField(2)
  double tournamentPower = 0;

  @HiveField(3)
  String tournamentPowerTrend = '';

  @HiveField(4)
  @JsonKey(name: '_id')
  String oid = '';

  TierList_PowerRanking();

  factory TierList_PowerRanking.fromJson(dynamic json)=> _$TierList_PowerRankingFromJson(json);

  dynamic toJson() => _$TierList_PowerRankingToJson(this);
}
