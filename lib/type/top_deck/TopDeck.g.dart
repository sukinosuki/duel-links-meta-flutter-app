// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TopDeck.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopDeck _$TopDeckFromJson(Map<String, dynamic> json) => TopDeck()
  ..author = json['author']
  ..created =
      json['created'] == null ? null : DateTime.parse(json['created'] as String)
  ..dollarsPrice = json['dollarsPrice'] as int
  ..extra =
      (json['extra'] as List<dynamic>).map(TopDeck_MainCard.fromJson).toList()
  ..gemsPrice = json['gemsPrice'] as int
  ..main =
      (json['main'] as List<dynamic>).map(TopDeck_MainCard.fromJson).toList()
  ..rush = json['rush'] as bool?
  ..skill = TopDeck_Skill.fromJson(json['skill'])
  ..tournamentNumber = json['tournamentNumber'] as String?
  ..tournamentPlacement = json['tournamentPlacement'] as String?
  ..tournamentType = json['tournamentType'] == null
      ? null
      : TopDeck_TournamentType.fromJson(json['tournamentType']);

Map<String, dynamic> _$TopDeckToJson(TopDeck instance) => <String, dynamic>{
      'author': instance.author,
      'created': instance.created?.toIso8601String(),
      'dollarsPrice': instance.dollarsPrice,
      'extra': instance.extra,
      'gemsPrice': instance.gemsPrice,
      'main': instance.main,
      'rush': instance.rush,
      'skill': instance.skill,
      'tournamentNumber': instance.tournamentNumber,
      'tournamentPlacement': instance.tournamentPlacement,
      'tournamentType': instance.tournamentType,
    };

TopDeck_MainCard _$TopDeck_MainCardFromJson(Map<String, dynamic> json) =>
    TopDeck_MainCard()
      ..amount = json['amount'] as int
      ..card = TopDeck_MainCard_Card.fromJson(json['card']);

Map<String, dynamic> _$TopDeck_MainCardToJson(TopDeck_MainCard instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'card': instance.card,
    };

TopDeck_MainCard_Card _$TopDeck_MainCard_CardFromJson(
        Map<String, dynamic> json) =>
    TopDeck_MainCard_Card()
      ..name = json['name'] as String
      ..oid = json['_id'] as String;

Map<String, dynamic> _$TopDeck_MainCard_CardToJson(
        TopDeck_MainCard_Card instance) =>
    <String, dynamic>{
      'name': instance.name,
      '_id': instance.oid,
    };

TopDeck_Skill _$TopDeck_SkillFromJson(Map<String, dynamic> json) =>
    TopDeck_Skill()
      ..name = json['name'] as String
      ..oid = json['_id'] as String
      ..archive = json['archive'] as bool;

Map<String, dynamic> _$TopDeck_SkillToJson(TopDeck_Skill instance) =>
    <String, dynamic>{
      'name': instance.name,
      '_id': instance.oid,
      'archive': instance.archive,
    };

TopDeck_TournamentType _$TopDeck_TournamentTypeFromJson(
        Map<String, dynamic> json) =>
    TopDeck_TournamentType()
      ..enumSuffix = json['enumSuffix'] as String
      ..icon = json['icon'] as String
      ..name = json['name'] as String
      ..shortName = json['shortName'] as String
      ..statsWeight = json['statsWeight'] as int;

Map<String, dynamic> _$TopDeck_TournamentTypeToJson(
        TopDeck_TournamentType instance) =>
    <String, dynamic>{
      'enumSuffix': instance.enumSuffix,
      'icon': instance.icon,
      'name': instance.name,
      'shortName': instance.shortName,
      'statsWeight': instance.statsWeight,
    };
