import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/tier_list_top_tier/TierList_TopTier.dart';

class TierListHiveDb {
  factory TierListHiveDb() => _instance;

  TierListHiveDb._constructor();

  static final _instance = TierListHiveDb._constructor();

  final _key = 'tier_list:top_tier';

  final _expireTimeKey = 'tier_list_expire_time:top_tier';

  Future<List<TierList_TopTier>?> get() async {
    List<TierList_TopTier>? list;

    try {
      final data = await MyHive.box.get(_key) as List<dynamic>?;
      list = data?.map((e) => e as TierList_TopTier).toList();
    } catch (e) {
      log('转换失败 $e');
    }

    return list;
  }

  Future<DateTime?> getExpireTime() async {
    DateTime? time;

    try {
      time = await MyHive.box.get(_expireTimeKey) as DateTime?;
    } catch (e) {
      log('转换失败 $e');
    }

    return time;
  }

  Future<void> set(List<TierList_TopTier> list) {
    return MyHive.box.put(_key, list);
  }

  Future<void> setExpireTime(DateTime time) {
    return MyHive.box.put(_expireTimeKey, time);
  }
}
