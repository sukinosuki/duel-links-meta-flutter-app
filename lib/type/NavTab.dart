import 'package:json_annotation/json_annotation.dart';

part 'NavTab.g.dart';

@JsonSerializable()
class NavTab {

  @JsonKey(name: '_id')
  String oid = '';

  String image = '';

  int id = 0;

  // @JsonKey(includeFromJson: false, includeToJson: true)
  String? title;

  NavTab({required this.id, this.title = ''});

  factory NavTab.fromJson(dynamic json) => _$NavTabFromJson(json);

  Map<String, dynamic> toJson() => _$NavTabToJson(this);

}
