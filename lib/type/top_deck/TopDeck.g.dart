// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TopDeck.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TopDeckAdapter extends TypeAdapter<TopDeck> {
  @override
  final int typeId = 17;

  @override
  TopDeck read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopDeck()
      ..created = fields[0] as DateTime?
      ..deckType = fields[1] as TopDeck_DeckType
      ..dollarsPrice = fields[2] as int
      ..gemsPrice = fields[3] as int
      ..skill = fields[4] as TopDeck_Skill?
      ..rankedType = fields[5] as TopDeck_RankedType?
      ..tournamentType = fields[6] as TopDeck_TournamentType?
      ..url = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, TopDeck obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.created)
      ..writeByte(1)
      ..write(obj.deckType)
      ..writeByte(2)
      ..write(obj.dollarsPrice)
      ..writeByte(3)
      ..write(obj.gemsPrice)
      ..writeByte(4)
      ..write(obj.skill)
      ..writeByte(5)
      ..write(obj.rankedType)
      ..writeByte(6)
      ..write(obj.tournamentType)
      ..writeByte(7)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopDeckAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopDeckDeckTypeAdapter extends TypeAdapter<TopDeck_DeckType> {
  @override
  final int typeId = 18;

  @override
  TopDeck_DeckType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopDeck_DeckType()
      ..name = fields[0] as String
      ..tier = fields[1] as int?;
  }

  @override
  void write(BinaryWriter writer, TopDeck_DeckType obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopDeckDeckTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopDeckSkillAdapter extends TypeAdapter<TopDeck_Skill> {
  @override
  final int typeId = 19;

  @override
  TopDeck_Skill read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopDeck_Skill()
      ..name = fields[0] as String
      ..oid = fields[1] as String
      ..archive = fields[2] as bool?;
  }

  @override
  void write(BinaryWriter writer, TopDeck_Skill obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.oid)
      ..writeByte(2)
      ..write(obj.archive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopDeckSkillAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopDeckTournamentTypeAdapter extends TypeAdapter<TopDeck_TournamentType> {
  @override
  final int typeId = 21;

  @override
  TopDeck_TournamentType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopDeck_TournamentType()
      ..enumSuffix = fields[0] as String
      ..icon = fields[1] as String
      ..name = fields[2] as String
      ..shortName = fields[3] as String
      ..statsWeight = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, TopDeck_TournamentType obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.enumSuffix)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.shortName)
      ..writeByte(4)
      ..write(obj.statsWeight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopDeckTournamentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TopDeckRankedTypeAdapter extends TypeAdapter<TopDeck_RankedType> {
  @override
  final int typeId = 20;

  @override
  TopDeck_RankedType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TopDeck_RankedType()
      ..icon = fields[0] as String
      ..name = fields[1] as String
      ..shortName = fields[2] as String
      ..statsWeight = fields[3] as int?;
  }

  @override
  void write(BinaryWriter writer, TopDeck_RankedType obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.icon)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.shortName)
      ..writeByte(3)
      ..write(obj.statsWeight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TopDeckRankedTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopDeck _$TopDeckFromJson(Map<String, dynamic> json) => TopDeck()
  ..author = json['author'] ?? ''
  ..created =
      json['created'] == null ? null : DateTime.parse(json['created'] as String)
  ..customTournamentName = json['customTournamentName'] as String?
  ..deckType =
      TopDeck_DeckType.fromJson(json['deckType'] as Map<String, dynamic>)
  ..dollarsPrice = json['dollarsPrice'] as int
  ..extra = (json['extra'] as List<dynamic>?)
          ?.map((e) => TopDeck_MainCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..gemsPrice = json['gemsPrice'] as int
  ..main = (json['main'] as List<dynamic>?)
          ?.map((e) => TopDeck_MainCard.fromJson(e as Map<String, dynamic>))
          .toList() ??
      []
  ..rush = json['rush'] as bool?
  ..skill = json['skill'] == null
      ? null
      : TopDeck_Skill.fromJson(json['skill'] as Map<String, dynamic>)
  ..tournamentNumber = json['tournamentNumber'] as String?
  ..tournamentPlacement = json['tournamentPlacement'] as String?
  ..rankedType = json['rankedType'] == null
      ? null
      : TopDeck_RankedType.fromJson(json['rankedType'])
  ..tournamentType = json['tournamentType'] == null
      ? null
      : TopDeck_TournamentType.fromJson(
          json['tournamentType'] as Map<String, dynamic>)
  ..url = json['url'] as String?;

Map<String, dynamic> _$TopDeckToJson(TopDeck instance) => <String, dynamic>{
      'author': instance.author,
      'created': instance.created?.toIso8601String(),
      'customTournamentName': instance.customTournamentName,
      'deckType': instance.deckType,
      'dollarsPrice': instance.dollarsPrice,
      'extra': instance.extra,
      'gemsPrice': instance.gemsPrice,
      'main': instance.main,
      'rush': instance.rush,
      'skill': instance.skill,
      'tournamentNumber': instance.tournamentNumber,
      'tournamentPlacement': instance.tournamentPlacement,
      'rankedType': instance.rankedType,
      'tournamentType': instance.tournamentType,
      'url': instance.url,
    };

TopDeck_DeckType _$TopDeck_DeckTypeFromJson(Map<String, dynamic> json) =>
    TopDeck_DeckType()
      ..name = json['name'] as String
      ..tier = json['tier'] as int?;

Map<String, dynamic> _$TopDeck_DeckTypeToJson(TopDeck_DeckType instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tier': instance.tier,
    };

TopDeck_MainCard _$TopDeck_MainCardFromJson(Map<String, dynamic> json) =>
    TopDeck_MainCard()
      ..amount = json['amount'] as int
      ..card =
          TopDeck_MainCard_Card.fromJson(json['card'] as Map<String, dynamic>);

Map<String, dynamic> _$TopDeck_MainCardToJson(TopDeck_MainCard instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'card': instance.card,
    };

TopDeck_MainCard_Card _$TopDeck_MainCard_CardFromJson(
        Map<String, dynamic> json) =>
    TopDeck_MainCard_Card()
      ..name = json['name'] as String
      ..oid = json['_id'] as String;

Map<String, dynamic> _$TopDeck_MainCard_CardToJson(
        TopDeck_MainCard_Card instance) =>
    <String, dynamic>{
      'name': instance.name,
      '_id': instance.oid,
    };

TopDeck_Skill _$TopDeck_SkillFromJson(Map<String, dynamic> json) =>
    TopDeck_Skill()
      ..name = json['name'] as String
      ..oid = json['_id'] as String
      ..archive = json['archive'] as bool?;

Map<String, dynamic> _$TopDeck_SkillToJson(TopDeck_Skill instance) =>
    <String, dynamic>{
      'name': instance.name,
      '_id': instance.oid,
      'archive': instance.archive,
    };

TopDeck_TournamentType _$TopDeck_TournamentTypeFromJson(
        Map<String, dynamic> json) =>
    TopDeck_TournamentType()
      ..enumSuffix = json['enumSuffix'] as String
      ..icon = json['icon'] as String
      ..name = json['name'] as String
      ..shortName = json['shortName'] as String
      ..statsWeight = json['statsWeight'] as int? ?? 0;

Map<String, dynamic> _$TopDeck_TournamentTypeToJson(
        TopDeck_TournamentType instance) =>
    <String, dynamic>{
      'enumSuffix': instance.enumSuffix,
      'icon': instance.icon,
      'name': instance.name,
      'shortName': instance.shortName,
      'statsWeight': instance.statsWeight,
    };

TopDeck_RankedType _$TopDeck_RankedTypeFromJson(Map<String, dynamic> json) =>
    TopDeck_RankedType()
      ..icon = json['icon'] as String
      ..name = json['name'] as String
      ..shortName = json['shortName'] as String
      ..statsWeight = json['statsWeight'] as int?;

Map<String, dynamic> _$TopDeck_RankedTypeToJson(TopDeck_RankedType instance) =>
    <String, dynamic>{
      'icon': instance.icon,
      'name': instance.name,
      'shortName': instance.shortName,
      'statsWeight': instance.statsWeight,
    };
