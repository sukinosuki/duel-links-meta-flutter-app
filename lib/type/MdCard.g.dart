// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MdCard.dart';

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
  ..rarity = json['rarity'] as String
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
      ..amount = json['amount'] as int
      ..type = json['type'] as String
      ..source = MdCard_Obtain_Source.fromJson(json['source']);

Map<String, dynamic> _$MdCard_ObtainToJson(MdCard_Obtain instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'type': instance.type,
      'source': instance.source,
    };

MdCard_Obtain_Source _$MdCard_Obtain_SourceFromJson(
        Map<String, dynamic> json) =>
    MdCard_Obtain_Source()
      ..name = json['name'] as String
      ..type = json['type'] as String?
      ..oid = json['_id'] as String;

Map<String, dynamic> _$MdCard_Obtain_SourceToJson(
        MdCard_Obtain_Source instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      '_id': instance.oid,
    };
