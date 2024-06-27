import 'package:json_annotation/json_annotation.dart';

part 'Skill.g.dart';

@JsonSerializable(includeIfNull: true)
class Skill {

  @JsonKey(defaultValue: false)
  bool archive = false;

  @JsonKey(defaultValue: false)
  bool rush = false;

  @JsonKey(defaultValue: '')
  String source = '';

  @JsonKey(name: '_id')
  String  oid='';

  String name = '';
  String description = '';

  List<Skill_RelatedCard> relatedCards = [];

  List<Skill_Character> characters = [];

  factory Skill.fromJson(dynamic json) => _$SkillFromJson(json);
  dynamic toJson() => _$SkillToJson(this);

  Skill();
}

@JsonSerializable()
class Skill_Character {
  @JsonKey(name: '_id')
  String oid = '';

  String how = '';

  Skill_Character_Character character = Skill_Character_Character();

  Skill_Character();

  factory Skill_Character
      .fromJson(dynamic json) => _$Skill_CharacterFromJson(json);

  dynamic toJson() => _$Skill_CharacterToJson(this);
}

@JsonSerializable()
class Skill_Character_Character {
  String name = '';
  String thumbnailImage = '';
  String victoryImage = '';
  @JsonKey(name: '_id')
  String oid = '';

  Skill_Character_Character();

  factory Skill_Character_Character
      .fromJson(dynamic json) => _$Skill_Character_CharacterFromJson(json);

  dynamic toJson() => _$Skill_Character_CharacterToJson(this);
}

@JsonSerializable()
class Skill_RelatedCard {

  @JsonKey(name: '_id')
  String oid = '';

  String name = '';

  Skill_RelatedCard();

  factory Skill_RelatedCard
      .fromJson(dynamic json) => _$Skill_RelatedCardFromJson(json);

  dynamic toJson() => _$Skill_RelatedCardToJson(this);
}
