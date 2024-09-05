import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';

class PacksHiveDb {
  factory PacksHiveDb() {
    return _instance;
  }

  PacksHiveDb._constructor();

  static final _instance = PacksHiveDb._constructor();

  final String _key = 'pack_set:list';
  final String _expireTimeKey = 'pack_set:list_last_fetch_date';

  Future<void> set(List<PackSet> data) {
    return MyHive.box2.put(_key, data);
  }

  Future<List<PackSet>?>? get() async {
    List<PackSet>? list;
    try {
      final data = await MyHive.box2.get(_key) as List?;
      list = data?.map((e) => e as PackSet).toList();
    } catch (e) {
      log('转换失败 $e');
    }

    return list;
  }

  Future<void> setExpireTime(DateTime date) {
    return MyHive.box2.put(_expireTimeKey, date);
  }

  Future<DateTime?>? getExpireTime() async {
    DateTime? time;
    try {
      time = await MyHive.box2.get(_expireTimeKey) as DateTime?;
    } catch (e) {
      log('转换失败 $e');
    }

    return time;
  }
}
