// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BanStatusCard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BanStatusCardAdapter extends TypeAdapter<BanStatusCard> {
  @override
  final int typeId = 11;

  @override
  BanStatusCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BanStatusCard()
      ..oid = fields[0] as String
      ..banStatus = fields[1] as String?;
  }

  @override
  void write(BinaryWriter writer, BanStatusCard obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.oid)
      ..writeByte(1)
      ..write(obj.banStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BanStatusCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanStatusCard _$BanStatusCardFromJson(Map<String, dynamic> json) =>
    BanStatusCard()
      ..oid = json['_id'] as String
      ..banStatus = json['banStatus'] as String?;

Map<String, dynamic> _$BanStatusCardToJson(BanStatusCard instance) =>
    <String, dynamic>{
      '_id': instance.oid,
      'banStatus': instance.banStatus,
    };
