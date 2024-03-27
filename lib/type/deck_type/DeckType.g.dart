// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DeckType.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeckType _$DeckTypeFromJson(Map<String, dynamic> json) => DeckType()
  ..card = json['card'] as String
  ..name = json['name'] as String
  ..thumbnailImage = json['thumbnailImage'] as String
  ..oid = json['_id'] as String
  ..deckBreakdown = DeckType_DeckBreakdown.fromJson(json['deckBreakdown']);

Map<String, dynamic> _$DeckTypeToJson(DeckType instance) => <String, dynamic>{
      'card': instance.card,
      'name': instance.name,
      'thumbnailImage': instance.thumbnailImage,
      '_id': instance.oid,
      'deckBreakdown': instance.deckBreakdown,
    };

DeckType_DeckBreakdown _$DeckType_DeckBreakdownFromJson(
        Map<String, dynamic> json) =>
    DeckType_DeckBreakdown()
      ..avgMainSize = json['avgMainSize'] as int
      ..avgSize = json['avgSize'] as int
      ..total = json['total'] as int
      ..skills = (json['skills'] as List<dynamic>)
          .map(DeckType_DeckBreakdown_Skill.fromJson)
          .toList()
      ..cards = (json['cards'] as List<dynamic>)
          .map(DeckType_DeckBreakdownCards.fromJson)
          .toList();

Map<String, dynamic> _$DeckType_DeckBreakdownToJson(
        DeckType_DeckBreakdown instance) =>
    <String, dynamic>{
      'avgMainSize': instance.avgMainSize,
      'avgSize': instance.avgSize,
      'total': instance.total,
      'skills': instance.skills,
      'cards': instance.cards,
    };

DeckType_DeckBreakdownCards _$DeckType_DeckBreakdownCardsFromJson(
        Map<String, dynamic> json) =>
    DeckType_DeckBreakdownCards()
      ..at = (json['at'] as num).toDouble()
      ..avgAt = (json['avgAt'] as num).toDouble()
      ..per = (json['per'] as num).toDouble()
      ..totalPer = (json['totalPer'] as num).toDouble()
      ..card = MdCard.fromJson(json['card'])
      ..trend = json['trend'] as String?;

Map<String, dynamic> _$DeckType_DeckBreakdownCardsToJson(
        DeckType_DeckBreakdownCards instance) =>
    <String, dynamic>{
      'at': instance.at,
      'avgAt': instance.avgAt,
      'per': instance.per,
      'totalPer': instance.totalPer,
      'card': instance.card,
      'trend': instance.trend,
    };

DeckType_DeckBreakdown_Skill _$DeckType_DeckBreakdown_SkillFromJson(
        Map<String, dynamic> json) =>
    DeckType_DeckBreakdown_Skill()
      ..aboveThresh = json['aboveThresh'] as bool
      ..count = json['count'] as int
      ..name = json['name'] as String
      ..recCount = json['recCount'] as int;

Map<String, dynamic> _$DeckType_DeckBreakdown_SkillToJson(
        DeckType_DeckBreakdown_Skill instance) =>
    <String, dynamic>{
      'aboveThresh': instance.aboveThresh,
      'count': instance.count,
      'name': instance.name,
      'recCount': instance.recCount,
    };
