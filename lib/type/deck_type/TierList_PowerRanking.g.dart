// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TierList_PowerRanking.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TierListPowerRankingAdapter extends TypeAdapter<TierList_PowerRanking> {
  @override
  final int typeId = 2;

  @override
  TierList_PowerRanking read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TierList_PowerRanking()
      ..name = fields[0] as String
      ..rush = fields[1] as bool?
      ..tournamentPower = fields[2] as double
      ..tournamentPowerTrend = fields[3] as String
      ..oid = fields[4] as String;
  }

  @override
  void write(BinaryWriter writer, TierList_PowerRanking obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.rush)
      ..writeByte(2)
      ..write(obj.tournamentPower)
      ..writeByte(3)
      ..write(obj.tournamentPowerTrend)
      ..writeByte(4)
      ..write(obj.oid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TierListPowerRankingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TierList_PowerRanking _$TierList_PowerRankingFromJson(
        Map<String, dynamic> json) =>
    TierList_PowerRanking()
      ..name = json['name'] as String
      ..rush = json['rush'] as bool?
      ..tournamentPower = (json['tournamentPower'] as num).toDouble()
      ..tournamentPowerTrend = json['tournamentPowerTrend'] as String
      ..oid = json['_id'] as String;

Map<String, dynamic> _$TierList_PowerRankingToJson(
        TierList_PowerRanking instance) =>
    <String, dynamic>{
      'name': instance.name,
      'rush': instance.rush,
      'tournamentPower': instance.tournamentPower,
      'tournamentPowerTrend': instance.tournamentPowerTrend,
      '_id': instance.oid,
    };
