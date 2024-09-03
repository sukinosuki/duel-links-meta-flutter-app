import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BanStatusCard.g.dart';

@JsonSerializable()
@HiveType(typeId: MyHive.ban_status_card)
class BanStatusCard {

  BanStatusCard();

  factory BanStatusCard.fromJson(dynamic json) => _$BanStatusCardFromJson(json as Map<String, dynamic>);

  @HiveField(0)
  @JsonKey(name: '_id')
  String oid = '';

  @HiveField(1)
  String? banStatus;

  Map<String, dynamic> toJson() => _$BanStatusCardToJson(this);
}
