import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/deck_type/DeckType.dart';

class DeckTypeDetailHiveDb {
  factory DeckTypeDetailHiveDb() {
    return _instance;
  }

  DeckTypeDetailHiveDb._constructor();

  static final DeckTypeDetailHiveDb _instance = DeckTypeDetailHiveDb._constructor();

  String _getKey(String deckTypeName) {
    return 'deck_type:$deckTypeName';
  }

  String _getExpireTimeKey(String deckTypeName) {
    return 'deck_type_fetch_date:$deckTypeName';
  }

  Future<DeckType?> get(String deckTypeName) async {
    final key = _getKey(deckTypeName);

    DeckType? deckType;
    try {
      deckType = await MyHive.box.get(key) as DeckType?;
    } catch (e) {
      log('转换失败 $e');
      return null;
    }

    return deckType;
  }

  Future<DateTime?> getExpireTime(String deckTypeName) async {
    final key = _getExpireTimeKey(deckTypeName);
    final date = await MyHive.box.get(key) as DateTime?;

    return date;
  }

  Future<void> set(DeckType deckType) {
    final key = _getKey(deckType.name);
    return MyHive.box.put(key, deckType);
  }

  Future<void> setExpireTime(DeckType deckType, DateTime date) {
    final key = _getExpireTimeKey(deckType.name);
    return MyHive.box.put(key, date);
  }
}
