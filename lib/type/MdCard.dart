import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'MdCard.g.dart';

@JsonSerializable(includeIfNull: false)
@HiveType(typeId: MyHive.md_card)
class MdCard {
  @HiveField(0)
  int? atk;

  @HiveField(1)
  String? attribute = '';

  @HiveField(2)
  int? def;

  @HiveField(3)
  String description = '';

  @HiveField(4)
  int? level  =  0;

  @HiveField(5)
  List<String> monsterType = [];

  @HiveField(6)
  String name = '';

  // @HiveField(7)
  List<MdCard_Obtain> obtain = [];

  @HiveField(8)
  String race = '';

  @HiveField(9)
  @JsonKey(defaultValue: '')
  String rarity = '';

  @HiveField(10)
  DateTime? release;

  @HiveField(11)
  String type = '';

  @HiveField(12)
  String? banStatus;

  @HiveField(13)
  int? linkRating;

  @HiveField(14)
  @JsonKey(name: '_id')
  String oid = '';

  MdCard();

  factory MdCard.fromJson(dynamic json) => _$MdCardFromJson(json as Map<String, dynamic>);

  dynamic toJson() => _$MdCardToJson(this);
}

@JsonSerializable()
class MdCard_Obtain {
  @JsonKey(defaultValue: 0)
  int amount = 0;

  @JsonKey(defaultValue: '')
  String type = '';

  @JsonKey(defaultValue: '')
  String subSource = '';

  MdCard_Obtain_Source source = MdCard_Obtain_Source();

  MdCard_Obtain();

  factory MdCard_Obtain.fromJson(Map<String, dynamic> json) => _$MdCard_ObtainFromJson(json);

  dynamic toJson() => _$MdCard_ObtainToJson(this);
}

@JsonSerializable(includeIfNull: true)
class MdCard_Obtain_Source {
  @JsonKey(defaultValue: '')
  String name = '';

  @JsonKey(defaultValue: '')
  String type = '';

  @JsonKey(name: '_id')
  String oid = '';

  MdCard_Obtain_Source();

  factory MdCard_Obtain_Source.fromJson(dynamic json) => _$MdCard_Obtain_SourceFromJson(json as Map<String, dynamic>);

  dynamic toJson() => _$MdCard_Obtain_SourceToJson(this);
}
