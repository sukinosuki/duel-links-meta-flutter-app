import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TierList_TopTier.g.dart';

@JsonSerializable()
@HiveType(typeId: MyHive.tier_list_top_tier)
class TierList_TopTier {
  @HiveField(0)
  String name;

  @HiveField(1)
  int tier;

  @HiveField(2)
  @JsonKey(name: '_id')
  String oid;

  @HiveField(3)
  @JsonKey(includeFromJson: false)
  double power = 0;

  TierList_TopTier({required this.name,  required this.oid, required this.tier});

  factory TierList_TopTier.fromJson(dynamic json) => _$TierList_TopTierFromJson(json as Map<String, dynamic>);

  dynamic toJson() => _$TierList_TopTierToJson(this);
}
