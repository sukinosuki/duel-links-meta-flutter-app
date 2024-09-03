import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Skill.g.dart';

@JsonSerializable(includeIfNull: true)
@HiveType(typeId: MyHive.skill)
class Skill {

  Skill();

  factory Skill.fromJson(dynamic json) => _$SkillFromJson(json as Map<String, dynamic>);

  @HiveField(0)
  @JsonKey(defaultValue: false)
  bool archive = false;

  @HiveField(1)
  @JsonKey(defaultValue: false)
  bool rush = false;

  @HiveField(2)
  @JsonKey(defaultValue: '')
  String source = '';

  @HiveField(3)
  @JsonKey(name: '_id')
  String  oid='';

  @HiveField(4)
  String name = '';

  @HiveField(5)
  String description = '';

  @HiveField(6)
  List<Skill_RelatedCard> relatedCards = [];

  @HiveField(7)
  List<Skill_Character> characters = [];

  dynamic toJson() => _$SkillToJson(this);
}

@HiveType(typeId: MyHive.skill_related_character)
@JsonSerializable()
class Skill_Character {

  Skill_Character();

  factory Skill_Character
      .fromJson(dynamic json) => _$Skill_CharacterFromJson(json as Map<String, dynamic>);

  @HiveField(0)
  @JsonKey(name: '_id')
  String oid = '';

  @HiveField(1)
  String how = '';

  @HiveField(2)
  Skill_Character_Character character = Skill_Character_Character();

  dynamic toJson() => _$Skill_CharacterToJson(this);
}

@HiveType(typeId: MyHive.skill_related_character_character)
@JsonSerializable()
class Skill_Character_Character {

  Skill_Character_Character();

  factory Skill_Character_Character
      .fromJson(dynamic json) => _$Skill_Character_CharacterFromJson(json as Map<String, dynamic>);

  @HiveField(0)
  String name = '';

  @HiveField(1)
  String thumbnailImage = '';

  @HiveField(2)
  String victoryImage = '';

  @HiveField(3)
  @JsonKey(name: '_id')
  String oid = '';

  dynamic toJson() => _$Skill_Character_CharacterToJson(this);
}

@HiveType(typeId: MyHive.skill_related_card)
@JsonSerializable()
class Skill_RelatedCard {

  Skill_RelatedCard();

  factory Skill_RelatedCard
      .fromJson(dynamic json) => _$Skill_RelatedCardFromJson(json as Map<String, dynamic>);

  @HiveField(0)
  @JsonKey(name: '_id')
  String oid = '';

  @HiveField(1)
  String name = '';

  dynamic toJson() => _$Skill_RelatedCardToJson(this);
}
