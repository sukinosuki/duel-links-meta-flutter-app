// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DeckType.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeckTypeAdapter extends TypeAdapter<DeckType> {
  @override
  final int typeId = 13;

  @override
  DeckType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckType()
      ..card = fields[0] as String
      ..name = fields[1] as String
      ..thumbnailImage = fields[2] as String
      ..oid = fields[3] as String
      ..deckBreakdown = fields[4] as DeckType_DeckBreakdown;
  }

  @override
  void write(BinaryWriter writer, DeckType obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.card)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.thumbnailImage)
      ..writeByte(3)
      ..write(obj.oid)
      ..writeByte(4)
      ..write(obj.deckBreakdown);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeckTypeDeckBreakdownAdapter extends TypeAdapter<DeckType_DeckBreakdown> {
  @override
  final int typeId = 14;

  @override
  DeckType_DeckBreakdown read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckType_DeckBreakdown()
      ..avgMainSize = fields[0] as int
      ..avgSize = fields[1] as int
      ..total = fields[2] as int
      ..skills = (fields[3] as List).cast<DeckType_DeckBreakdown_Skill>()
      ..cards = (fields[4] as List).cast<DeckType_DeckBreakdownCards>();
  }

  @override
  void write(BinaryWriter writer, DeckType_DeckBreakdown obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.avgMainSize)
      ..writeByte(1)
      ..write(obj.avgSize)
      ..writeByte(2)
      ..write(obj.total)
      ..writeByte(3)
      ..write(obj.skills)
      ..writeByte(4)
      ..write(obj.cards);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckTypeDeckBreakdownAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeckTypeDeckBreakdownCardsAdapter
    extends TypeAdapter<DeckType_DeckBreakdownCards> {
  @override
  final int typeId = 16;

  @override
  DeckType_DeckBreakdownCards read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckType_DeckBreakdownCards()
      ..at = fields[0] as double
      ..avgAt = fields[1] as double
      ..per = fields[2] as double
      ..totalPer = fields[3] as double
      ..trend = fields[4] as String?
      ..card = fields[5] as MdCard;
  }

  @override
  void write(BinaryWriter writer, DeckType_DeckBreakdownCards obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.at)
      ..writeByte(1)
      ..write(obj.avgAt)
      ..writeByte(2)
      ..write(obj.per)
      ..writeByte(3)
      ..write(obj.totalPer)
      ..writeByte(4)
      ..write(obj.trend)
      ..writeByte(5)
      ..write(obj.card);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckTypeDeckBreakdownCardsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DeckTypeDeckBreakdownSkillAdapter
    extends TypeAdapter<DeckType_DeckBreakdown_Skill> {
  @override
  final int typeId = 15;

  @override
  DeckType_DeckBreakdown_Skill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeckType_DeckBreakdown_Skill()
      ..aboveThresh = fields[0] as bool
      ..count = fields[1] as int
      ..name = fields[2] as String
      ..recCount = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, DeckType_DeckBreakdown_Skill obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.aboveThresh)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.recCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeckTypeDeckBreakdownSkillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeckType _$DeckTypeFromJson(Map<String, dynamic> json) => DeckType()
  ..card = json['card'] as String
  ..name = json['name'] as String
  ..thumbnailImage = json['thumbnailImage'] as String
  ..oid = json['_id'] as String
  ..deckBreakdown = DeckType_DeckBreakdown.fromJson(json['deckBreakdown']);

Map<String, dynamic> _$DeckTypeToJson(DeckType instance) => <String, dynamic>{
      'card': instance.card,
      'name': instance.name,
      'thumbnailImage': instance.thumbnailImage,
      '_id': instance.oid,
      'deckBreakdown': instance.deckBreakdown,
    };

DeckType_DeckBreakdown _$DeckType_DeckBreakdownFromJson(
        Map<String, dynamic> json) =>
    DeckType_DeckBreakdown()
      ..avgMainSize = json['avgMainSize'] as int
      ..avgSize = json['avgSize'] as int
      ..total = json['total'] as int
      ..skills = (json['skills'] as List<dynamic>)
          .map(DeckType_DeckBreakdown_Skill.fromJson)
          .toList()
      ..cards = (json['cards'] as List<dynamic>)
          .map(DeckType_DeckBreakdownCards.fromJson)
          .toList();

Map<String, dynamic> _$DeckType_DeckBreakdownToJson(
        DeckType_DeckBreakdown instance) =>
    <String, dynamic>{
      'avgMainSize': instance.avgMainSize,
      'avgSize': instance.avgSize,
      'total': instance.total,
      'skills': instance.skills,
      'cards': instance.cards,
    };

DeckType_DeckBreakdownCards _$DeckType_DeckBreakdownCardsFromJson(
        Map<String, dynamic> json) =>
    DeckType_DeckBreakdownCards()
      ..at = (json['at'] as num).toDouble()
      ..avgAt = (json['avgAt'] as num).toDouble()
      ..per = (json['per'] as num).toDouble()
      ..totalPer = (json['totalPer'] as num).toDouble()
      ..trend = json['trend'] as String?
      ..card = MdCard.fromJson(json['card']);

Map<String, dynamic> _$DeckType_DeckBreakdownCardsToJson(
        DeckType_DeckBreakdownCards instance) =>
    <String, dynamic>{
      'at': instance.at,
      'avgAt': instance.avgAt,
      'per': instance.per,
      'totalPer': instance.totalPer,
      'trend': instance.trend,
      'card': instance.card,
    };

DeckType_DeckBreakdown_Skill _$DeckType_DeckBreakdown_SkillFromJson(
        Map<String, dynamic> json) =>
    DeckType_DeckBreakdown_Skill()
      ..aboveThresh = json['aboveThresh'] as bool
      ..count = json['count'] as int
      ..name = json['name'] as String
      ..recCount = json['recCount'] as int;

Map<String, dynamic> _$DeckType_DeckBreakdown_SkillToJson(
        DeckType_DeckBreakdown_Skill instance) =>
    <String, dynamic>{
      'aboveThresh': instance.aboveThresh,
      'count': instance.count,
      'name': instance.name,
      'recCount': instance.recCount,
    };
