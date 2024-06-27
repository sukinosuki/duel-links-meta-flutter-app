import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:hive/hive.dart';

// @HiveType(typeId: MyHive.expire_data)
class ExpireData<T> {

  @HiveField(0)
  DateTime expire;

  @HiveField(1)
  T data;

  ExpireData({required this.data, required this.expire});
}