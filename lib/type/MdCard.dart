import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'MdCard.g.dart';

@JsonSerializable(includeIfNull: false)
class MdCard {
  int? atk = 0;
  String? attribute = '';

  int? def = 0;

  String description = '';

  int? level = 0;

  List<String> monsterType = [];

  String name = '';

  List<MdCard_Obtain> obtain = [];

  String race = '';

  String rarity = '';

  DateTime? release;

  String type = '';

  String? banStatus;

  int? linkRating;

  @JsonKey(name: '_id')
  String oid = '';

  MdCard();

  factory MdCard.fromJson(dynamic json) => _$MdCardFromJson(json);

  dynamic toJson() => _$MdCardToJson(this);
}

@JsonSerializable()
class MdCard_Obtain {
  int amount = 0;
  String type = '';
  MdCard_Obtain_Source source = MdCard_Obtain_Source();

  MdCard_Obtain();

  factory MdCard_Obtain.fromJson(dynamic json) => _$MdCard_ObtainFromJson(json);

  dynamic toJson() => _$MdCard_ObtainToJson(this);
}

@JsonSerializable(includeIfNull: true)
class MdCard_Obtain_Source {
  String name = '';
  String? type = '';

  @JsonKey(name: '_id')
  String oid = '';

  MdCard_Obtain_Source();

  factory MdCard_Obtain_Source.fromJson(dynamic json) => _$MdCard_Obtain_SourceFromJson(json);

  dynamic toJson() => _$MdCard_Obtain_SourceToJson(this);
}
