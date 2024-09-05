import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/deck_type/TierList_PowerRanking.dart';

class PowerRankingsHiveDb {

  factory PowerRankingsHiveDb() => _instance;

  PowerRankingsHiveDb._constructor();

  static final _instance = PowerRankingsHiveDb._constructor();

  String _getKey(bool isRush) {
    return 'tier_list:power_rankings:${isRush ? 'rush' :''}';
  }

  String _getExpireTimeKey(bool isRush) {
    return 'tier_list_expire_time:power_rankings:${isRush ? 'rush' : ''}';
  }

  Future<List<TierList_PowerRanking>?>? get({required bool isRush}) async{
    final key = _getKey(isRush);
    List<TierList_PowerRanking>? list;
    try {
      final data = await MyHive.box2.get(key) as List<dynamic>?;
      list = data?.map((e) => e as TierList_PowerRanking).toList();
    } catch(e){
      log('转换失败 $e');
    }

    return list;
  }

  Future<void> set(List<TierList_PowerRanking> list, {required bool isRush}) {
    final key = _getKey(isRush);
    return MyHive.box2.put(key, list);
  }

  Future<DateTime?>? getExpireTime({required bool isRush}) async{
    final key = _getExpireTimeKey(isRush);
    DateTime? time;
    try {
      time = await MyHive.box2.get(key) as DateTime?;
    } catch(e){
      log('转换失败 $e');
    }

    return time;
  }

  Future<void> setExpireTime(DateTime time, {required bool isRush}) {
    final key = _getExpireTimeKey(isRush);

    return MyHive.box2.put(key, time);
  }

}