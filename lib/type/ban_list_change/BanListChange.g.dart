// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BanListChange.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BanListChangeAdapter extends TypeAdapter<BanListChange> {
  @override
  final int typeId = 8;

  @override
  BanListChange read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BanListChange()
      ..announced = fields[0] as DateTime?
      ..date = fields[1] as DateTime?
      ..rush = fields[2] as bool
      ..oid = fields[3] as String
      ..changes = (fields[4] as List).cast<BanListChange_Change>();
  }

  @override
  void write(BinaryWriter writer, BanListChange obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.announced)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.rush)
      ..writeByte(3)
      ..write(obj.oid)
      ..writeByte(4)
      ..write(obj.changes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BanListChangeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BanListChangeChangeAdapter extends TypeAdapter<BanListChange_Change> {
  @override
  final int typeId = 9;

  @override
  BanListChange_Change read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BanListChange_Change()
      ..to = fields[0] as String?
      ..from = fields[1] as String?
      ..card = fields[2] as BanListChange_Change_Card?;
  }

  @override
  void write(BinaryWriter writer, BanListChange_Change obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.to)
      ..writeByte(1)
      ..write(obj.from)
      ..writeByte(2)
      ..write(obj.card);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BanListChangeChangeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BanListChangeChangeCardAdapter
    extends TypeAdapter<BanListChange_Change_Card> {
  @override
  final int typeId = 10;

  @override
  BanListChange_Change_Card read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BanListChange_Change_Card()
      ..oid = fields[0] as String
      ..name = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, BanListChange_Change_Card obj) {
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
      other is BanListChangeChangeCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanListChange _$BanListChangeFromJson(Map<String, dynamic> json) =>
    BanListChange()
      ..announced = json['announced'] == null
          ? null
          : DateTime.parse(json['announced'] as String)
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String)
      ..rush = json['rush'] as bool? ?? false
      ..oid = json['oid'] as String? ?? ''
      ..changes = (json['changes'] as List<dynamic>?)
              ?.map(BanListChange_Change.fromJson)
              .toList() ??
          [];

Map<String, dynamic> _$BanListChangeToJson(BanListChange instance) =>
    <String, dynamic>{
      'announced': instance.announced?.toIso8601String(),
      'date': instance.date?.toIso8601String(),
      'rush': instance.rush,
      'oid': instance.oid,
      'changes': instance.changes,
    };

BanListChange_Change _$BanListChange_ChangeFromJson(
        Map<String, dynamic> json) =>
    BanListChange_Change()
      ..to = json['to'] as String?
      ..from = json['from'] as String?
      ..card = json['card'] == null
          ? null
          : BanListChange_Change_Card.fromJson(json['card']);

Map<String, dynamic> _$BanListChange_ChangeToJson(
        BanListChange_Change instance) =>
    <String, dynamic>{
      'to': instance.to,
      'from': instance.from,
      'card': instance.card,
    };

BanListChange_Change_Card _$BanListChange_Change_CardFromJson(
        Map<String, dynamic> json) =>
    BanListChange_Change_Card()
      ..oid = json['_id'] as String? ?? ''
      ..name = json['name'] as String? ?? '';

Map<String, dynamic> _$BanListChange_Change_CardToJson(
        BanListChange_Change_Card instance) =>
    <String, dynamic>{
      '_id': instance.oid,
      'name': instance.name,
    };

BanListChange_LinkedArticle _$BanListChange_LinkedArticleFromJson(
        Map<String, dynamic> json) =>
    BanListChange_LinkedArticle()
      ..oid = json['oid'] as String? ?? ''
      ..url = json['url'] as String? ?? ''
      ..title = json['title'] as String? ?? '';

Map<String, dynamic> _$BanListChange_LinkedArticleToJson(
        BanListChange_LinkedArticle instance) =>
    <String, dynamic>{
      'oid': instance.oid,
      'url': instance.url,
      'title': instance.title,
    };
