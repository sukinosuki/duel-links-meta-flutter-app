import 'package:json_annotation/json_annotation.dart';

part 'TierList_PowerRanking.g.dart';

@JsonSerializable(includeIfNull: true)
class TierList_PowerRanking {
  String name = '';

  bool? rush = false;

  double tournamentPower = 0;

  String tournamentPowerTrend = '';

  @JsonKey(name: '_id')
  String oid = '';

  TierList_PowerRanking();

  factory TierList_PowerRanking.fromJson(dynamic json)=> _$TierList_PowerRankingFromJson(json);

  dynamic toJson() => _$TierList_PowerRankingToJson(this);
}
