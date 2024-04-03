// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BanListChange.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanListChange _$BanListChangeFromJson(Map<String, dynamic> json) =>
    BanListChange()
      ..announced = json['announced'] == null
          ? null
          : DateTime.parse(json['announced'] as String)
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String)
      ..rush = json['rush'] as bool? ?? false
      ..oid = json['oid'] as String? ?? ''
      ..linkedArticle = json['linkedArticle'] == null
          ? null
          : BanListChange_LinkedArticle.fromJson(json['linkedArticle'])
      ..changes = (json['changes'] as List<dynamic>?)
              ?.map(BanListChange_Change.fromJson)
              .toList() ??
          [];

Map<String, dynamic> _$BanListChangeToJson(BanListChange instance) =>
    <String, dynamic>{
      'announced': instance.announced?.toIso8601String(),
      'date': instance.date?.toIso8601String(),
      'rush': instance.rush,
      'oid': instance.oid,
      'linkedArticle': instance.linkedArticle,
      'changes': instance.changes,
    };

BanListChange_Change _$BanListChange_ChangeFromJson(
        Map<String, dynamic> json) =>
    BanListChange_Change()
      ..to = json['to'] as String? ?? ''
      ..from = json['from'] as String?
      ..card = json['card'] == null
          ? null
          : BanListChange_Change_Card.fromJson(json['card']);

Map<String, dynamic> _$BanListChange_ChangeToJson(
        BanListChange_Change instance) =>
    <String, dynamic>{
      'to': instance.to,
      'from': instance.from,
      'card': instance.card,
    };

BanListChange_Change_Card _$BanListChange_Change_CardFromJson(
        Map<String, dynamic> json) =>
    BanListChange_Change_Card()
      ..oid = json['_id'] as String? ?? ''
      ..name = json['name'] as String? ?? '';

Map<String, dynamic> _$BanListChange_Change_CardToJson(
        BanListChange_Change_Card instance) =>
    <String, dynamic>{
      '_id': instance.oid,
      'name': instance.name,
    };

BanListChange_LinkedArticle _$BanListChange_LinkedArticleFromJson(
        Map<String, dynamic> json) =>
    BanListChange_LinkedArticle()
      ..oid = json['oid'] as String? ?? ''
      ..url = json['url'] as String? ?? ''
      ..title = json['title'] as String? ?? '';

Map<String, dynamic> _$BanListChange_LinkedArticleToJson(
        BanListChange_LinkedArticle instance) =>
    <String, dynamic>{
      'oid': instance.oid,
      'url': instance.url,
      'title': instance.title,
    };
