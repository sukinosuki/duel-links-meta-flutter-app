import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';

class TopDeckHiveDb {

  factory TopDeckHiveDb() {
    return _instance;
  }
  TopDeckHiveDb._controller();

  static final _instance = TopDeckHiveDb._controller();


  String _getKey(bool isRush){
    return 'top_deck:list:${isRush ? 'rush' : 'speed'}';
  }

  String _getExpireTimeKey(bool isRush) {
    return 'top_deck:list:${isRush ? 'rush' : 'speed'}:refresh';
  }

  Future<List<TopDeck>?> get({required bool isRush})async {
    final key = _getKey(isRush);

    List<TopDeck>? list;
    try {
      final data = await MyHive.box2.get(key) as List<dynamic>?;
      list  = data?.map((e) => e as TopDeck).toList();
    }catch(e) {
      log('转换失败 $e');
    }

    return list;
  }

  Future<DateTime?> getExpireTime({required bool isRush}) async{
    final key = _getExpireTimeKey(isRush);
    DateTime? time;
    try {
      time = await MyHive.box2.get(key) as DateTime?;
    } catch(e) {
      log('转换失败 $e');
    }

    return time;
  }

  Future<void> set(List<TopDeck> list, {required bool isRush}) {
    final key = _getKey(isRush);

    return MyHive.box2.put(key, list);
  }

  Future<void> setExpireTime(DateTime time, {required bool isRush}) {
    final key = _getExpireTimeKey(isRush);

    return MyHive.box2.put(key, time);
  }
}