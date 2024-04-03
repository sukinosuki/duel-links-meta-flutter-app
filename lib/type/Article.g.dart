// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Article _$ArticleFromJson(Map<String, dynamic> json) => Article()
  ..id = json['_id'] as String
  ..url = json['url'] as String
  ..title = json['title'] as String
  ..category = json['category'] as String? ?? ''
  ..image = json['image'] as String
  ..subCategory = json['subCategory'] as String?
  ..featured = json['featured'] as bool? ?? false
  ..description = json['description'] as String
  ..date = json['date'] == null ? null : DateTime.parse(json['date'] as String);

Map<String, dynamic> _$ArticleToJson(Article instance) {
  final val = <String, dynamic>{
    '_id': instance.id,
    'url': instance.url,
    'title': instance.title,
    'category': instance.category,
    'image': instance.image,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('subCategory', instance.subCategory);
  val['featured'] = instance.featured;
  val['description'] = instance.description;
  writeNotNull('date', instance.date?.toIso8601String());
  return val;
}
