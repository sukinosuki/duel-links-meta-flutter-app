// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill()
  ..archive = json['archive'] as bool? ?? false
  ..rush = json['rush'] as bool? ?? false
  ..source = json['source'] as String? ?? ''
  ..oid = json['_id'] as String
  ..name = json['name'] as String
  ..description = json['description'] as String
  ..relatedCards = (json['relatedCards'] as List<dynamic>)
      .map(Skill_RelatedCard.fromJson)
      .toList()
  ..characters = (json['characters'] as List<dynamic>)
      .map(Skill_Character.fromJson)
      .toList();

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
      'archive': instance.archive,
      'rush': instance.rush,
      'source': instance.source,
      '_id': instance.oid,
      'name': instance.name,
      'description': instance.description,
      'relatedCards': instance.relatedCards,
      'characters': instance.characters,
    };

Skill_Character _$Skill_CharacterFromJson(Map<String, dynamic> json) =>
    Skill_Character()
      ..oid = json['_id'] as String
      ..how = json['how'] as String
      ..character = Skill_Character_Character.fromJson(json['character']);

Map<String, dynamic> _$Skill_CharacterToJson(Skill_Character instance) =>
    <String, dynamic>{
      '_id': instance.oid,
      'how': instance.how,
      'character': instance.character,
    };

Skill_Character_Character _$Skill_Character_CharacterFromJson(
        Map<String, dynamic> json) =>
    Skill_Character_Character()
      ..name = json['name'] as String
      ..thumbnailImage = json['thumbnailImage'] as String
      ..victoryImage = json['victoryImage'] as String
      ..oid = json['_id'] as String;

Map<String, dynamic> _$Skill_Character_CharacterToJson(
        Skill_Character_Character instance) =>
    <String, dynamic>{
      'name': instance.name,
      'thumbnailImage': instance.thumbnailImage,
      'victoryImage': instance.victoryImage,
      '_id': instance.oid,
    };

Skill_RelatedCard _$Skill_RelatedCardFromJson(Map<String, dynamic> json) =>
    Skill_RelatedCard()
      ..oid = json['_id'] as String
      ..name = json['name'] as String;

Map<String, dynamic> _$Skill_RelatedCardToJson(Skill_RelatedCard instance) =>
    <String, dynamic>{
      '_id': instance.oid,
      'name': instance.name,
    };
