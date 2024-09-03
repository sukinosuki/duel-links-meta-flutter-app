// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Skill.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SkillAdapter extends TypeAdapter<Skill> {
  @override
  final int typeId = 22;

  @override
  Skill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Skill()
      ..archive = fields[0] as bool
      ..rush = fields[1] as bool
      ..source = fields[2] as String
      ..oid = fields[3] as String
      ..name = fields[4] as String
      ..description = fields[5] as String
      ..relatedCards = (fields[6] as List).cast<Skill_RelatedCard>()
      ..characters = (fields[7] as List).cast<Skill_Character>();
  }

  @override
  void write(BinaryWriter writer, Skill obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.archive)
      ..writeByte(1)
      ..write(obj.rush)
      ..writeByte(2)
      ..write(obj.source)
      ..writeByte(3)
      ..write(obj.oid)
      ..writeByte(4)
      ..write(obj.name)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.relatedCards)
      ..writeByte(7)
      ..write(obj.characters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SkillCharacterAdapter extends TypeAdapter<Skill_Character> {
  @override
  final int typeId = 24;

  @override
  Skill_Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Skill_Character()
      ..oid = fields[0] as String
      ..how = fields[1] as String
      ..character = fields[2] as Skill_Character_Character;
  }

  @override
  void write(BinaryWriter writer, Skill_Character obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.oid)
      ..writeByte(1)
      ..write(obj.how)
      ..writeByte(2)
      ..write(obj.character);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillCharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SkillCharacterCharacterAdapter
    extends TypeAdapter<Skill_Character_Character> {
  @override
  final int typeId = 25;

  @override
  Skill_Character_Character read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Skill_Character_Character()
      ..name = fields[0] as String
      ..thumbnailImage = fields[1] as String
      ..victoryImage = fields[2] as String
      ..oid = fields[3] as String;
  }

  @override
  void write(BinaryWriter writer, Skill_Character_Character obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.thumbnailImage)
      ..writeByte(2)
      ..write(obj.victoryImage)
      ..writeByte(3)
      ..write(obj.oid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillCharacterCharacterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SkillRelatedCardAdapter extends TypeAdapter<Skill_RelatedCard> {
  @override
  final int typeId = 23;

  @override
  Skill_RelatedCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Skill_RelatedCard()
      ..oid = fields[0] as String
      ..name = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, Skill_RelatedCard obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.oid)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SkillRelatedCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
