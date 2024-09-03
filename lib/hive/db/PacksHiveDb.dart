import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';

class PackHiveDb {
  static const String _key = 'pack_set:list';
  static const String _expireTimeKey = 'pack_set:list_last_fetch_date';

  static Future<void> set(List<PackSet> data) {
    return MyHive.box2.put(_key, data);
  }

  static Future<List<PackSet>?>? get() async {
    List<PackSet>? list;
    try {
      final data = await MyHive.box2.get(_key) as List?;
      list = data?.map((e) => e as PackSet).toList();
    } catch (e) {
      log('转换失败 $e');
    }

    return list;
  }

  static Future<void> setExpireTime(DateTime date) {
    return MyHive.box2.put(_expireTimeKey, date);
  }

  static Future<DateTime?>? getExpireTime() async {
    DateTime? time;
    try {
      time = await MyHive.box2.get(_expireTimeKey) as DateTime?;
    } catch (e) {
      log('转换失败 $e');
    }

    return time;
  }
}
