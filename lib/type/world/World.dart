import 'package:json_annotation/json_annotation.dart';

part 'World.g.dart';

@JsonSerializable()
class World {
  @JsonKey(defaultValue: '')
  String bannerImage = '';
  @JsonKey(defaultValue: '')
  String name = '';

  DateTime? release;
  @JsonKey(defaultValue: '')
  String shortName = '';

  @JsonKey(name: '_id')
  String oid = '';

  World();

  factory World.fromJson(dynamic json) => _$WorldFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$WorldToJson(this);
}
