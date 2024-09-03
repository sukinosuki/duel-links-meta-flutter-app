import 'package:json_annotation/json_annotation.dart';

part 'Character.g.dart';

@JsonSerializable()
class Character {

  Character();

  factory Character.fromJson(dynamic json) => _$CharacterFromJson(json as Map<String, dynamic>);

  @JsonKey(name: '_id', defaultValue: '')
  String oid = '';

  @JsonKey(defaultValue: '')
  String name = '';

  @JsonKey(defaultValue: '')
  String victoryImage = '';

  @JsonKey(defaultValue: '')
  String thumbnailImage = '';

  @JsonKey(defaultValue: [])
  List<Character_World> worlds = [];

  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}

@JsonSerializable()
class Character_LinkedArticle {


  Character_LinkedArticle();

  factory Character_LinkedArticle.fromJson(dynamic json) => _$Character_LinkedArticleFromJson(json as Map<String, dynamic>);

  @JsonKey(defaultValue: '')
  String description = '';

  DateTime? date;
  @JsonKey(defaultValue: '')
  String category = '';

  @JsonKey(defaultValue: '')
  String title = '';

  @JsonKey(defaultValue: '')
  String image = '';

  Map<String, dynamic> toJson() => _$Character_LinkedArticleToJson(this);
}

@JsonSerializable()
class Character_World {

  Character_World();

  factory Character_World.fromJson(dynamic json) => _$Character_WorldFromJson(json as Map<String, dynamic>);
  @JsonKey(defaultValue: '')
  String name = '';

  @JsonKey(defaultValue: '')
  String shortName = '';

  @JsonKey(name: '_id', defaultValue: '')
  String oid = '';

  Map<String, dynamic> toJson() => _$Character_WorldToJson(this);
}
