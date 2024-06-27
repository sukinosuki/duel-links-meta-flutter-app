// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MdCard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MdCardAdapter extends TypeAdapter<MdCard> {
  @override
  final int typeId = 7;

  @override
  MdCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MdCard()
      ..atk = fields[0] as int?
      ..attribute = fields[1] as String?
      ..def = fields[2] as int?
      ..description = fields[3] as String
      ..level = fields[4] as int?
      ..monsterType = (fields[5] as List).cast<String>()
      ..name = fields[6] as String
      ..race = fields[8] as String
      ..rarity = fields[9] as String
      ..release = fields[10] as DateTime?
      ..type = fields[11] as String
      ..banStatus = fields[12] as String?
      ..linkRating = fields[13] as int?
      ..oid = fields[14] as String;
  }

  @override
  void write(BinaryWriter writer, MdCard obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.atk)
      ..writeByte(1)
      ..write(obj.attribute)
      ..writeByte(2)
      ..write(obj.def)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.level)
      ..writeByte(5)
      ..write(obj.monsterType)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.race)
      ..writeByte(9)
      ..write(obj.rarity)
      ..writeByte(10)
      ..write(obj.release)
      ..writeByte(11)
      ..write(obj.type)
      ..writeByte(12)
      ..write(obj.banStatus)
      ..writeByte(13)
      ..write(obj.linkRating)
      ..writeByte(14)
      ..write(obj.oid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MdCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MdCard _$MdCardFromJson(Map<String, dynamic> json) => MdCard()
  ..atk = json['atk'] as int?
  ..attribute = json['attribute'] as String?
  ..def = json['def'] as int?
  ..description = json['description'] as String
  ..level = json['level'] as int?
  ..monsterType =
      (json['monsterType'] as List<dynamic>).map((e) => e as String).toList()
  ..name = json['name'] as String
  ..obtain =
      (json['obtain'] as List<dynamic>).map(MdCard_Obtain.fromJson).toList()
  ..race = json['race'] as String
  ..rarity = json['rarity'] as String? ?? ''
  ..release =
      json['release'] == null ? null : DateTime.parse(json['release'] as String)
  ..type = json['type'] as String
  ..banStatus = json['banStatus'] as String?
  ..linkRating = json['linkRating'] as int?
  ..oid = json['_id'] as String;

Map<String, dynamic> _$MdCardToJson(MdCard instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('atk', instance.atk);
  writeNotNull('attribute', instance.attribute);
  writeNotNull('def', instance.def);
  val['description'] = instance.description;
  writeNotNull('level', instance.level);
  val['monsterType'] = instance.monsterType;
  val['name'] = instance.name;
  val['obtain'] = instance.obtain;
  val['race'] = instance.race;
  val['rarity'] = instance.rarity;
  writeNotNull('release', instance.release?.toIso8601String());
  val['type'] = instance.type;
  writeNotNull('banStatus', instance.banStatus);
  writeNotNull('linkRating', instance.linkRating);
  val['_id'] = instance.oid;
  return val;
}

MdCard_Obtain _$MdCard_ObtainFromJson(Map<String, dynamic> json) =>
    MdCard_Obtain()
      ..amount = json['amount'] as int? ?? 0
      ..type = json['type'] as String? ?? ''
      ..subSource = json['subSource'] as String? ?? ''
      ..source = MdCard_Obtain_Source.fromJson(json['source']);

Map<String, dynamic> _$MdCard_ObtainToJson(MdCard_Obtain instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'type': instance.type,
      'subSource': instance.subSource,
      'source': instance.source,
    };

MdCard_Obtain_Source _$MdCard_Obtain_SourceFromJson(
        Map<String, dynamic> json) =>
    MdCard_Obtain_Source()
      ..name = json['name'] as String? ?? ''
      ..type = json['type'] as String? ?? ''
      ..oid = json['_id'] as String;

Map<String, dynamic> _$MdCard_Obtain_SourceToJson(
        MdCard_Obtain_Source instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      '_id': instance.oid,
    };
