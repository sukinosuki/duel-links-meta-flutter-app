import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DeckType.g.dart';

@JsonSerializable()
@HiveType(typeId: MyHive.deck_type)
class DeckType {
  @HiveField(0)
  String card = '';
  @HiveField(1)
  String name = '';

  @HiveField(2)
  String thumbnailImage = '';

  @HiveField(3)
  @JsonKey(name: '_id')
  String oid = '';

  @HiveField(4)
  DeckType_DeckBreakdown deckBreakdown = DeckType_DeckBreakdown();

  DeckType();

  factory DeckType.fromJson(dynamic json) => _$DeckTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DeckTypeToJson(this);
}

@HiveType(typeId: MyHive.deck_type_deck_breakdown)
@JsonSerializable()
class DeckType_DeckBreakdown {
  @HiveField(0)
  int avgMainSize = 0;

  @HiveField(1)
  int avgSize = 0;

  @HiveField(2)
  int total = 0;

  @HiveField(3)
  List<DeckType_DeckBreakdown_Skill> skills = [];

  @HiveField(4)
  List<DeckType_DeckBreakdownCards> cards = [];

  DeckType_DeckBreakdown();

  factory DeckType_DeckBreakdown.fromJson(dynamic json) => _$DeckType_DeckBreakdownFromJson(json);

  Map<String, dynamic> toJson() => _$DeckType_DeckBreakdownToJson(this);
}

@JsonSerializable()
@HiveType(typeId: MyHive.deck_type_deck_breakdown_card)
class DeckType_DeckBreakdownCards {
  @HiveField(0)
  double at = 0;

  @HiveField(1)
  double avgAt = 0;

  @HiveField(2)
  double per = 0;

  @HiveField(3)
  double totalPer = 0;

  @HiveField(4)
  String? trend;

  @HiveField(5)
  MdCard card = MdCard();

  DeckType_DeckBreakdownCards();

  factory DeckType_DeckBreakdownCards.fromJson(dynamic json) => _$DeckType_DeckBreakdownCardsFromJson(json);

  Map<String, dynamic> toJson() => _$DeckType_DeckBreakdownCardsToJson(this);
}

@JsonSerializable()
@HiveType(typeId: MyHive.deck_type_deck_breakdown_skill)
class DeckType_DeckBreakdown_Skill {
  @HiveField(0)
  bool aboveThresh = false;

  @HiveField(1)
  int count = 0;

  @HiveField(2)
  String name = '';

  @HiveField(3)
  int recCount = 0;

  DeckType_DeckBreakdown_Skill();

  factory DeckType_DeckBreakdown_Skill.fromJson(dynamic json) => _$DeckType_DeckBreakdown_SkillFromJson(json);

  Map<String, dynamic> toJson() => _$DeckType_DeckBreakdown_SkillToJson(this);
}
