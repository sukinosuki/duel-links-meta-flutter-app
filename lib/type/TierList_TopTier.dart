import 'package:json_annotation/json_annotation.dart';

part 'TierList_TopTier.g.dart';

@JsonSerializable()
class TierList_TopTier {
  String name;

  int tier;

  @JsonKey(name: '_id')
  String oid;

  @JsonKey(includeFromJson: false)
  double power = 0;

  TierList_TopTier({required this.name,  required this.oid, required this.tier});

  factory TierList_TopTier.fromJson(dynamic json) => _$TierList_TopTierFromJson(json);

  dynamic toJson() => _$TierList_TopTierToJson(this);
}
