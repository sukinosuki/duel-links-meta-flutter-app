import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'NavTab.g.dart';

@JsonSerializable()
@HiveType(typeId: MyHive.nav_tab)
class NavTab {

  NavTab({required this.id, this.title = '', this.url});

  factory NavTab.fromJson(dynamic json) => _$NavTabFromJson(json as Map<String, dynamic>);

  @JsonKey(name: '_id')
  String oid = '';

  @HiveField(0)
  String image = '';

  @HiveField(1)
  int id = 0;

  // @JsonKey(includeFromJson: false, includeToJson: true)
  String? title;

  String? url;

  Map<String, dynamic> toJson() => _$NavTabToJson(this);
}
