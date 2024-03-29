import 'package:json_annotation/json_annotation.dart';

part 'PackSet.g.dart';

@JsonSerializable()
class PackSet {
  @JsonKey(name: '_id', defaultValue: '')
  String oid = '';

  @JsonKey(defaultValue: '')
  String type = '';

  DateTime? release;

  @JsonKey(defaultValue: '')
  String name = '';

  @JsonKey(defaultValue: '')
  String bannerImage = '';

  PackSet_Icon? icon = PackSet_Icon();

  PackSet();

  factory PackSet.fromJson(dynamic json) => _$PackSetFromJson(json);
  dynamic toJson() => _$PackSetToJson(this);
}

@JsonSerializable()
class PackSet_Icon {
  @JsonKey(defaultValue: '')
  String name = '';

  @JsonKey(name: '_id', defaultValue: '')
  String oid = '';

  PackSet_Icon();

  factory PackSet_Icon.fromJson(dynamic json) => _$PackSet_IconFromJson(json);
  dynamic toJson() => _$PackSet_IconToJson(this);
}
