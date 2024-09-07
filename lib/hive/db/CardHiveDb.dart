import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/MdCard.dart';

class CardHiveDb {
  factory CardHiveDb() {
    return _instance;
  }

  CardHiveDb._constructor();

  static final CardHiveDb _instance = CardHiveDb._constructor();

  String _getKey(String id) {
    return 'card:$id';
  }

  Future<MdCard?> get(String id) async {
    final key = _getKey(id);

    MdCard? card;
    try {
      card = await MyHive.box.get(key) as MdCard?;
    } catch (e) {
      log('转换失败');
      return null;
    }

    return card;
  }

  Future<void> set(MdCard card) async {
    final key = _getKey(card.oid);

    return MyHive.box.put(key, card);
  }
}
