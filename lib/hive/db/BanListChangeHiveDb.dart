import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/ban_list_change/BanListChange.dart';

class BanListChangeHiveDb {
  factory BanListChangeHiveDb() {
    return _instance;
  }

  BanListChangeHiveDb._constructor();

  static final BanListChangeHiveDb _instance = BanListChangeHiveDb._constructor();

  final String _key = 'ban_list_change:list';
  final String _expireKey = 'ban_list_change:fetch_date';

  Future<List<BanListChange>?> get() async {
    List<BanListChange>? data;

    try {
      final list = await MyHive.box.get(_key) as List<dynamic>?;
      data = list?.map((e) => e as BanListChange).toList();
    } catch (e) {
      log('转换失败 $e');
      return null;
    }

    return data;
  }

  Future<DateTime?> getExpireTime() async {
    DateTime? expireTime;
    try {
      expireTime = await MyHive.box.get(_expireKey) as DateTime?;
    } catch (e) {
      log('转换失败 $e');
      return null;
    }
    return expireTime;
  }

  Future<void> set(List<BanListChange> data) {
    return MyHive.box.put(_key, data);
  }

  Future<void> setExpireTime(DateTime time) {
    return MyHive.box.put(_expireKey, time);
  }
}
