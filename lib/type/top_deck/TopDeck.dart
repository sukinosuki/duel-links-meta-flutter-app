import 'package:json_annotation/json_annotation.dart';

import '../MdCard.dart';

part 'TopDeck.g.dart';

@JsonSerializable()
class TopDeck {
  dynamic author;
  DateTime? created;
  int dollarsPrice = 0;
  List<TopDeck_MainCard> extra = [];
  int gemsPrice = 0;

  List<TopDeck_MainCard> main = [];
  bool? rush;
  TopDeck_Skill skill = TopDeck_Skill();
  String? tournamentNumber;
  String? tournamentPlacement;
  TopDeck_TournamentType? tournamentType;

  TopDeck();

  factory TopDeck.fromJson(dynamic json) => _$TopDeckFromJson(json);
  dynamic toJson() => _$TopDeckToJson(this);
}

@JsonSerializable()
class TopDeck_MainCard {
  int amount = 0;

  TopDeck_MainCard_Card card = TopDeck_MainCard_Card();

  @JsonKey(includeFromJson: false)
  MdCard? _card;

  TopDeck_MainCard();

  factory TopDeck_MainCard.fromJson(dynamic json) => _$TopDeck_MainCardFromJson(json);
  dynamic toJson() => _$TopDeck_MainCardToJson(this);
}

@JsonSerializable()
class TopDeck_MainCard_Card {
  String name = '';
  @JsonKey(name: '_id')
  String oid = '';

  TopDeck_MainCard_Card();

  factory TopDeck_MainCard_Card.fromJson(dynamic json) => _$TopDeck_MainCard_CardFromJson(json);
  dynamic toJson() => _$TopDeck_MainCard_CardToJson(this);
}

@JsonSerializable()
class TopDeck_Skill {
  String name = '';

  @JsonKey(name: '_id')
  String oid = '';

  bool archive = false;

  TopDeck_Skill();

  factory TopDeck_Skill.fromJson(dynamic json) => _$TopDeck_SkillFromJson(json);
  dynamic toJson() => _$TopDeck_SkillToJson(this);
}

@JsonSerializable()
class TopDeck_TournamentType {
  String enumSuffix = '';
  String icon = '';
  String name = '';
  String shortName = '';
  int statsWeight = 0;

  TopDeck_TournamentType();

  factory TopDeck_TournamentType.fromJson(dynamic json) => _$TopDeck_TournamentTypeFromJson(json);
  dynamic toJson() => _$TopDeck_TournamentTypeToJson(this);
}
