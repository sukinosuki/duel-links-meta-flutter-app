import 'package:json_annotation/json_annotation.dart';

import 'TopDeck.dart';

part 'TopDeckSimple.g.dart';

@JsonSerializable()
class TopDeckSimple {

  @JsonKey(name: '_id')
  String oid = '';

  DateTime? created;

  TopDeck_DeckType deckType = TopDeck_DeckType();

  TopDeck_RankedType? rankedType;
  TopDeck_TournamentType? tournamentType;

  TopDeckSimple();

  factory TopDeckSimple.fromJson(dynamic json) => _$TopDeckSimpleFromJson(json);
  dynamic toJson() => _$TopDeckSimpleToJson(this);
}
