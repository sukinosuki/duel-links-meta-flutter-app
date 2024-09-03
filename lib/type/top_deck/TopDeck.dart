import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TopDeck.g.dart';

@JsonSerializable()
@HiveType(typeId: MyHive.top_deck)
class TopDeck {
  @JsonKey(defaultValue: '')
  dynamic author;

  @HiveField(0)
  DateTime? created;

  String? customTournamentName;

  @HiveField(1)
  TopDeck_DeckType deckType = TopDeck_DeckType();

  @HiveField(2)
  int dollarsPrice = 0;

  @JsonKey(defaultValue: [])
  List<TopDeck_MainCard> extra = [];

  @HiveField(3)
  int gemsPrice = 0;

  @JsonKey(defaultValue: [])
  List<TopDeck_MainCard> main = [];

  bool? rush;

  @HiveField(4)
  TopDeck_Skill? skill = TopDeck_Skill();

  String? tournamentNumber;

  String? tournamentPlacement;

  @HiveField(5)
  TopDeck_RankedType? rankedType;

  @HiveField(6)
  TopDeck_TournamentType? tournamentType;

  @HiveField(7)
  String? url;

  TopDeck();

  factory TopDeck.fromJson(dynamic json) => _$TopDeckFromJson(json as Map<String, dynamic>);
  dynamic toJson() => _$TopDeckToJson(this);
}

@JsonSerializable()
@HiveType(typeId: MyHive.top_deck_deck_type)
class TopDeck_DeckType {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  int? tier;

  TopDeck_DeckType();

  factory TopDeck_DeckType.fromJson(Map<String, dynamic> json) => _$TopDeck_DeckTypeFromJson(json);
  dynamic toJson() => _$TopDeck_DeckTypeToJson(this);
}

@JsonSerializable()
class TopDeck_MainCard {
  int amount = 0;

  TopDeck_MainCard_Card card = TopDeck_MainCard_Card();

  @JsonKey(includeFromJson: false)
  MdCard? _card;

  TopDeck_MainCard();

  factory TopDeck_MainCard.fromJson(Map<String, dynamic> json) => _$TopDeck_MainCardFromJson(json);
  dynamic toJson() => _$TopDeck_MainCardToJson(this);
}

@JsonSerializable()
class TopDeck_MainCard_Card {
  String name = '';
  @JsonKey(name: '_id')
  String oid = '';

  TopDeck_MainCard_Card();

  factory TopDeck_MainCard_Card.fromJson(Map<String, dynamic> json) => _$TopDeck_MainCard_CardFromJson(json);
  dynamic toJson() => _$TopDeck_MainCard_CardToJson(this);
}

@JsonSerializable()
@HiveType(typeId: MyHive.top_deck_skill)
class TopDeck_Skill {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  @JsonKey(name: '_id')
  String oid = '';

  @HiveField(2)
  bool? archive;

  TopDeck_Skill();

  factory TopDeck_Skill.fromJson(Map<String, dynamic> json) => _$TopDeck_SkillFromJson(json);
  dynamic toJson() => _$TopDeck_SkillToJson(this);
}

@JsonSerializable()
@HiveType(typeId: MyHive.top_deck_tournament_type)
class TopDeck_TournamentType {
  @HiveField(0)
  String enumSuffix = '';

  @HiveField(1)
  String icon = '';

  @HiveField(2)
  String name = '';

  @HiveField(3)
  String shortName = '';

  @HiveField(4)
  @JsonKey(defaultValue: 0)
  int statsWeight = 0;

  TopDeck_TournamentType();

  factory TopDeck_TournamentType.fromJson(Map<String, dynamic> json) => _$TopDeck_TournamentTypeFromJson(json);
  dynamic toJson() => _$TopDeck_TournamentTypeToJson(this);
}


@JsonSerializable()
@HiveType(typeId: MyHive.top_deck_ranked_type)
class TopDeck_RankedType {
  @HiveField(0)
  String icon = '';

  @HiveField(1)
  String name = '';

  @HiveField(2)
  String shortName = '';

  @HiveField(3)
  int? statsWeight;

  TopDeck_RankedType();

  factory TopDeck_RankedType.fromJson(dynamic json) => _$TopDeck_RankedTypeFromJson(json as Map<String, dynamic>);
  dynamic toJson() => _$TopDeck_RankedTypeToJson(this);
}

