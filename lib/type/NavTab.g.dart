// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NavTab.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NavTabAdapter extends TypeAdapter<NavTab> {
  @override
  final int typeId = 12;

  @override
  NavTab read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NavTab(
      id: fields[1] as int,
    )..image = fields[0] as String;
  }

  @override
  void write(BinaryWriter writer, NavTab obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.image)
      ..writeByte(1)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NavTabAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NavTab _$NavTabFromJson(Map<String, dynamic> json) => NavTab(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
    )
      ..oid = json['_id'] as String
      ..image = json['image'] as String;

Map<String, dynamic> _$NavTabToJson(NavTab instance) => <String, dynamic>{
      '_id': instance.oid,
      'image': instance.image,
      'id': instance.id,
      'title': instance.title,
    };
