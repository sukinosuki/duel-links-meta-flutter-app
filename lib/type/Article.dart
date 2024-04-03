import 'package:json_annotation/json_annotation.dart';

part 'Article.g.dart';

@JsonSerializable(includeIfNull: false)
class Article {
  @JsonKey(name: '_id')
  String id = '';

  String url = '';

  String title = '';

  @JsonKey(defaultValue: '')
  String category = '';

  String image = '';

  String? subCategory = '';

  @JsonKey(defaultValue: false)
  bool featured = false;

  String description = '';

  DateTime? date;

  Article();

  // factory Article.fromJson(Map<String, dynamic> json) => _$ArticleFromJson(json);
  factory Article.fromJson(dynamic json) => _$ArticleFromJson(json);

  dynamic toJson() => _$ArticleToJson(this);
}
