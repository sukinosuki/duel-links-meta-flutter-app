import 'package:json_annotation/json_annotation.dart';

part 'SkillStats.g.dart';

@JsonSerializable()
class SkillStats {

  @JsonKey(defaultValue: 0)
  int count = 0;

  @JsonKey(defaultValue: '')
  String name = '';

  @JsonKey(defaultValue: 0)
  double percentage = 0;

  int? tier;

  SkillStats();
  factory SkillStats.fromJson(dynamic json) => _$SkillStatsFromJson(json);
  dynamic toJson() => _$SkillStatsToJson(this);
}

@JsonSerializable()
class SkillStats_CoverCard {
  @JsonKey(name: '_id')
  String oid = '';

  String name = '';

  SkillStats_CoverCard();
  factory SkillStats_CoverCard.fromJson(dynamic json) => _$SkillStats_CoverCardFromJson(json);
  dynamic toJson() => _$SkillStats_CoverCardToJson(this);
}