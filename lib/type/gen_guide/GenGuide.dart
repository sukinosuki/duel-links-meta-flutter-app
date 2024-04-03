import 'package:json_annotation/json_annotation.dart';

part 'GenGuide.g.dart';

@JsonSerializable()
class GenGuide {

  @JsonKey(defaultValue: '')
  String oid = '';

  DateTime? selectionBoxEnd;
  DateTime? selectionBoxStart;

  DateTime? halfPriceBoxes;
  DateTime? halfPriceEnd;


}

@JsonSerializable()
class GenGuide_TrendingUp{

  String? trend;

  @JsonKey(defaultValue: '')
  String name= '';


}