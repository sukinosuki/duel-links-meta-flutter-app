// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TopDeckSimple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TopDeckSimple _$TopDeckSimpleFromJson(Map<String, dynamic> json) =>
    TopDeckSimple()
      ..oid = json['_id'] as String
      ..created = json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String)
      ..deckType = TopDeck_DeckType.fromJson(json['deckType'])
      ..rankedType = json['rankedType'] == null
          ? null
          : TopDeck_RankedType.fromJson(json['rankedType'])
      ..tournamentType = json['tournamentType'] == null
          ? null
          : TopDeck_TournamentType.fromJson(json['tournamentType']);

Map<String, dynamic> _$TopDeckSimpleToJson(TopDeckSimple instance) =>
    <String, dynamic>{
      '_id': instance.oid,
      'created': instance.created?.toIso8601String(),
      'deckType': instance.deckType,
      'rankedType': instance.rankedType,
      'tournamentType': instance.tournamentType,
    };
