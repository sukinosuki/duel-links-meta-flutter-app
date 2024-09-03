import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'BanListChange.g.dart';

@JsonSerializable()
@HiveType(typeId: MyHive.ban_list_chnage)
class BanListChange {

  BanListChange();

  factory BanListChange.fromJson(dynamic json) => _$BanListChangeFromJson(json as Map<String, dynamic>);

  dynamic toJson() => _$BanListChangeToJson(this);

  @HiveField(0)
  DateTime? announced;

  @HiveField(1)
  DateTime? date;

  @JsonKey(includeFromJson: false)
  String formattedMonthDay = '';

  @HiveField(2)
  @JsonKey(defaultValue: false)
  bool rush = false;

  @HiveField(3)
  @JsonKey(defaultValue: '')
  String oid = '';

  @HiveField(4)
  @JsonKey(defaultValue: [])
  List<BanListChange_Change> changes = [] ;
}

@JsonSerializable()
@HiveType(typeId: MyHive.ban_list_chnage_changes)
class BanListChange_Change {

  BanListChange_Change();

  factory BanListChange_Change.fromJson(dynamic json) => _$BanListChange_ChangeFromJson(json as Map<String, dynamic>);
  @HiveField(0)
  String? to = '';

  @HiveField(1)
  String? from = '';

  @HiveField(2)
  BanListChange_Change_Card? card;

  @JsonKey(includeFromJson: false)
  MdCard card2 = MdCard();

  dynamic toJson() => _$BanListChange_ChangeToJson(this);
}

@JsonSerializable()
@HiveType(typeId: MyHive.ban_list_chnage_changes_card)
class BanListChange_Change_Card {

  BanListChange_Change_Card();

  factory BanListChange_Change_Card.fromJson(dynamic json) => _$BanListChange_Change_CardFromJson(json as Map<String, dynamic>);
  @JsonKey(name: '_id', defaultValue: '')
  @HiveField(0)
  String oid = '';

  @HiveField(1)
  @JsonKey(defaultValue: '')
  String name = '';

  dynamic toJson() => _$BanListChange_Change_CardToJson(this);
}

@JsonSerializable()
class BanListChange_LinkedArticle {

  BanListChange_LinkedArticle();

  factory BanListChange_LinkedArticle.fromJson(dynamic json) => _$BanListChange_LinkedArticleFromJson(json as Map<String, dynamic>);
  @JsonKey(defaultValue: '')
  String oid = '';

  @JsonKey(defaultValue: '')
  String url = '';

  @JsonKey(defaultValue: '')
  String title = '';

  dynamic toJson() => _$BanListChange_LinkedArticleToJson(this);
}
