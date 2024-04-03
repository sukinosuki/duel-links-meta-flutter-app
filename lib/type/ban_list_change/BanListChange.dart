import 'package:json_annotation/json_annotation.dart';

import '../MdCard.dart';

part 'BanListChange.g.dart';

@JsonSerializable()
class BanListChange {
  DateTime? announced;
  DateTime? date;

  @JsonKey(includeFromJson: false)
  String formattedMonthDay = '';

  @JsonKey(defaultValue: false)
  bool rush = false;

  @JsonKey(defaultValue: '')
  String oid = '';

  BanListChange_LinkedArticle? linkedArticle;

  @JsonKey(defaultValue: [])
  List<BanListChange_Change> changes = [];

  BanListChange();

  factory BanListChange.fromJson(dynamic json) => _$BanListChangeFromJson(json);

  dynamic toJson() => _$BanListChangeToJson(this);
}

@JsonSerializable()
class BanListChange_Change {
  // @JsonKey(defaultValue: '')
  String? to = '';

  // @JsonKey(defaultValue: '')
  String? from = '';

  BanListChange_Change_Card? card;

  @JsonKey(includeFromJson: false)
  MdCard card2 = MdCard();

  BanListChange_Change();

  factory BanListChange_Change.fromJson(dynamic json) => _$BanListChange_ChangeFromJson(json);

  dynamic toJson() => _$BanListChange_ChangeToJson(this);
}

@JsonSerializable()
class BanListChange_Change_Card {
  @JsonKey(name: '_id', defaultValue: '')
  String oid = '';

  @JsonKey(defaultValue: '')
  String name = '';

  BanListChange_Change_Card();

  factory BanListChange_Change_Card.fromJson(dynamic json) => _$BanListChange_Change_CardFromJson(json);

  dynamic toJson() => _$BanListChange_Change_CardToJson(this);
}

@JsonSerializable()
class BanListChange_LinkedArticle {
  @JsonKey(defaultValue: '')
  String oid = '';

  @JsonKey(defaultValue: '')
  String url = '';

  @JsonKey(defaultValue: '')
  String title = '';

  BanListChange_LinkedArticle();

  factory BanListChange_LinkedArticle.fromJson(dynamic json) => _$BanListChange_LinkedArticleFromJson(json);

  dynamic toJson() => _$BanListChange_LinkedArticleToJson(this);
}
