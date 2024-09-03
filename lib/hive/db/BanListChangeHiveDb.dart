import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/ban_list_change/BanListChange.dart';

class BanListChangeHiveDb {
  static const String _key = 'ban_list_change:list';
  static const String _expireKey = 'ban_list_change:fetch_date';

  static Future<List<BanListChange>?> get() async {
    List<BanListChange>? data;
    try {
      final list = await MyHive.box2.get(_key) as List<dynamic>?;
      data = list?.map((e) => e as BanListChange).toList();
    } catch (e) {
      return null;
    }

    return data;
  }

  static Future<DateTime?> getExpireTime() async {
    DateTime? expireTime;
    try {
      expireTime = await MyHive.box2.get(_expireKey) as DateTime?;
    } catch (e) {
      return null;
    }
    return expireTime;
  }

  static Future<void> set(List<BanListChange> data) {
    return MyHive.box2.put(_key, data);
  }

  static Future<void> setExpireTime(DateTime time) {
    return MyHive.box2.put(_expireKey, time);
  }
}
