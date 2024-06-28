import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BanStatusCard.g.dart';

@JsonSerializable()
@HiveType(typeId: MyHive.ban_status_card)
class BanStatusCard {

  @HiveField(0)
  @JsonKey(name: '_id')
  String oid = '';

  @HiveField(1)
  String? banStatus;

  BanStatusCard();

  factory BanStatusCard.fromJson(dynamic json) => _$BanStatusCardFromJson(json);

  Map<String, dynamic> toJson() => _$BanStatusCardToJson(this);
}