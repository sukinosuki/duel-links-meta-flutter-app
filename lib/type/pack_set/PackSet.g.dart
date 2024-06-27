// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PackSet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PackSetAdapter extends TypeAdapter<PackSet> {
  @override
  final int typeId = 5;

  @override
  PackSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PackSet()
      ..oid = fields[0] as String
      ..type = fields[1] as String
      ..release = fields[2] as DateTime?
      ..name = fields[3] as String
      ..bannerImage = fields[4] as String
      ..icon = fields[5] as PackSet_Icon?;
  }

  @override
  void write(BinaryWriter writer, PackSet obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.oid)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.release)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.bannerImage)
      ..writeByte(5)
      ..write(obj.icon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PackSetIconAdapter extends TypeAdapter<PackSet_Icon> {
  @override
  final int typeId = 6;

  @override
  PackSet_Icon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PackSet_Icon()
      ..name = fields[0] as String
      ..oid = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, PackSet_Icon obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.oid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackSetIconAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackSet _$PackSetFromJson(Map<String, dynamic> json) => PackSet()
  ..oid = json['_id'] as String? ?? ''
  ..type = json['type'] as String? ?? ''
  ..release =
      json['release'] == null ? null : DateTime.parse(json['release'] as String)
  ..name = json['name'] as String? ?? ''
  ..bannerImage = json['bannerImage'] as String? ?? ''
  ..icon = json['icon'] == null ? null : PackSet_Icon.fromJson(json['icon']);

Map<String, dynamic> _$PackSetToJson(PackSet instance) => <String, dynamic>{
      '_id': instance.oid,
      'type': instance.type,
      'release': instance.release?.toIso8601String(),
      'name': instance.name,
      'bannerImage': instance.bannerImage,
      'icon': instance.icon,
    };

PackSet_Icon _$PackSet_IconFromJson(Map<String, dynamic> json) => PackSet_Icon()
  ..name = json['name'] as String? ?? ''
  ..oid = json['_id'] as String? ?? '';

Map<String, dynamic> _$PackSet_IconToJson(PackSet_Icon instance) =>
    <String, dynamic>{
      'name': instance.name,
      '_id': instance.oid,
    };
