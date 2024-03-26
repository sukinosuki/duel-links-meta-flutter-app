import 'package:duel_links_meta/type/MdCard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DeckType.g.dart';

@JsonSerializable()
class DeckType {

  String card = '';
  String name ='';

  String thumbnailImage='';

  @JsonKey(name: '_id')
  String oid = '';

  DeckType_DeckBreakdown deckBreakdown = DeckType_DeckBreakdown();

  DeckType();

  factory DeckType.fromJson(dynamic json) => _$DeckTypeFromJson(json);

  Map<String, dynamic> toJson() => _$DeckTypeToJson(this);
}

@JsonSerializable()
class DeckType_DeckBreakdown {
  int avgMainSize = 0;
  int avgSize =30;
  int total = 0;
  List<DeckType_DeckBreakdown_Skill> skills = [];

  List<DeckType_DeckBreakdownCards> cards = [];

  DeckType_DeckBreakdown();

  factory DeckType_DeckBreakdown.fromJson(dynamic json) => _$DeckType_DeckBreakdownFromJson(json);
  Map<String, dynamic> toJson() => _$DeckType_DeckBreakdownToJson(this);
}

@JsonSerializable()
class DeckType_DeckBreakdownCards {
  double at = 0;
  double avgAt  =0;
  double per = 0;
  double totalPer = 0;
  MdCard card = MdCard();
  String? trend;

  DeckType_DeckBreakdownCards();

  factory DeckType_DeckBreakdownCards.fromJson(dynamic json) => _$DeckType_DeckBreakdownCardsFromJson(json);
  Map<String, dynamic> toJson() => _$DeckType_DeckBreakdownCardsToJson(this);
}

@JsonSerializable()
class DeckType_DeckBreakdown_Skill {
  bool aboveThresh = false;

  int count = 0;

  String name  = '';

  int recCount = 0;

  DeckType_DeckBreakdown_Skill();


  factory DeckType_DeckBreakdown_Skill.fromJson(dynamic json) => _$DeckType_DeckBreakdown_SkillFromJson(json);
  Map<String, dynamic> toJson() => _$DeckType_DeckBreakdown_SkillToJson(this);
}