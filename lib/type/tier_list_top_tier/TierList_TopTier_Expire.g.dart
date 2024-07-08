// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TierList_TopTier_Expire.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TierListTopTierExpireAdapter
    extends TypeAdapter<TierList_TopTier_Expire> {
  @override
  final int typeId = 3;

  @override
  TierList_TopTier_Expire read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TierList_TopTier_Expire(
      data: (fields[1] as List).cast<TierList_TopTier>(),
      expire: fields[0] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TierList_TopTier_Expire obj) {
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
      other is TierListTopTierExpireAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
