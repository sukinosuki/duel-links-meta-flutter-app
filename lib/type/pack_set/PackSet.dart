import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'PackSet.g.dart';

@JsonSerializable()
@HiveType(typeId: MyHive.pack_set)
class PackSet {

  PackSet();

  factory PackSet.fromJson(dynamic json) => _$PackSetFromJson(json);
  @HiveField(0)
  @JsonKey(name: '_id', defaultValue: '')
  String oid = '';

  @HiveField(1)
  @JsonKey(defaultValue: '')
  String type = '';

  @HiveField(2)
  DateTime? release;

  @HiveField(3)
  @JsonKey(defaultValue: '')
  String name = '';

  @HiveField(4)
  @JsonKey(defaultValue: '')
  String bannerImage = '';

  @HiveField(5)
  PackSet_Icon? icon = PackSet_Icon();
  dynamic toJson() => _$PackSetToJson(this);
}

@HiveType(typeId: MyHive.pack_set_icon)
@JsonSerializable()
class PackSet_Icon {

  PackSet_Icon();

  factory PackSet_Icon.fromJson(dynamic json) => _$PackSet_IconFromJson(json);
  dynamic toJson() => _$PackSet_IconToJson(this);

  @HiveField(0)
  @JsonKey(defaultValue: '')
  String name = '';

  @HiveField(1)
  @JsonKey(name: '_id', defaultValue: '')
  String oid = '';
}
