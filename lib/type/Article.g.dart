// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Article.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 26;

  @override
  Article read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Article()
      ..id = fields[0] as String
      ..url = fields[1] as String
      ..title = fields[2] as String
      ..category = fields[3] as String
      ..image = fields[4] as String
      ..subCategory = fields[5] as String?
      ..featured = fields[6] as bool
      ..description = fields[7] as String
      ..date = fields[8] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.subCategory)
      ..writeByte(6)
      ..write(obj.featured)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
