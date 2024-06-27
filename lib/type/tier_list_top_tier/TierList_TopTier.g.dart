// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TierList_TopTier.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TierListTopTierAdapter extends TypeAdapter<TierList_TopTier> {
  @override
  final int typeId = 1;

  @override
  TierList_TopTier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TierList_TopTier(
      name: fields[0] as String,
      oid: fields[2] as String,
      tier: fields[1] as int,
    )..power = fields[3] as double;
  }

  @override
  void write(BinaryWriter writer, TierList_TopTier obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.tier)
      ..writeByte(2)
      ..write(obj.oid)
      ..writeByte(3)
      ..write(obj.power);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TierListTopTierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TierList_TopTier _$TierList_TopTierFromJson(Map<String, dynamic> json) =>
    TierList_TopTier(
      name: json['name'] as String,
      oid: json['_id'] as String,
      tier: json['tier'] as int,
    );

Map<String, dynamic> _$TierList_TopTierToJson(TierList_TopTier instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tier': instance.tier,
      '_id': instance.oid,
    };
