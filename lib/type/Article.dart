import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Article.g.dart';

@JsonSerializable(includeIfNull: false)
@HiveType(typeId: MyHive.article)
class Article {

  Article();

  factory Article.fromJson(dynamic json) => _$ArticleFromJson(json as Map<String, dynamic>);

  @HiveField(0)
  @JsonKey(name: '_id')
  String id = '';

  @HiveField(1)
  String url = '';

  @HiveField(2)
  String title = '';

  @HiveField(3)
  @JsonKey(defaultValue: '')
  String category = '';

  @HiveField(4)
  String image = '';

  @HiveField(5)
  String? subCategory = '';

  @HiveField(6)
  @JsonKey(defaultValue: false)
  bool featured = false;

  @HiveField(7)
  String description = '';

  @HiveField(8)
  DateTime? date;

  dynamic toJson() => _$ArticleToJson(this);
}
