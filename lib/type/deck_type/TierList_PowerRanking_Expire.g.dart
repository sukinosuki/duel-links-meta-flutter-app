// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TierList_PowerRanking_Expire.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TierListPowerRankingExpireAdapter
    extends TypeAdapter<TierList_PowerRanking_Expire> {
  @override
  final int typeId = 4;

  @override
  TierList_PowerRanking_Expire read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TierList_PowerRanking_Expire(
      data: (fields[1] as List).cast<TierList_PowerRanking>(),
      expire: fields[0] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TierList_PowerRanking_Expire obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.expire)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TierListPowerRankingExpireAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
