import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/deck_type/DeckType.dart';

class DeckTypeDetailHiveDb {
  static String _getKey(String deckTypeName) {
    return 'deck_type:$deckTypeName';
  }

  static String _getExpireTimeKey(String deckTypeName) {
    return 'deck_type_fetch_date:$deckTypeName';
  }

  static Future<DeckType?> getDetail(String deckTypeName) async {
    final key = _getKey(deckTypeName);

    DeckType? deckType;
    try {
      deckType = await MyHive.box2.get(key) as DeckType?;
    } catch (e) {
      return null;
    }

    return deckType;
  }

  static Future<DateTime?> getDetailExpireDate(String deckTypeName) async {
    final key = _getExpireTimeKey(deckTypeName);
    final date = await MyHive.box2.get(key) as DateTime?;

    return date;
  }

  static Future<void> setDeckType(DeckType deckType) {
    final key = _getKey(deckType.name);
    return MyHive.box2.put(key, deckType);
  }

  static Future<void> setDeckTypeExpireDate(DeckType deckType, DateTime date) {
    final key = _getExpireTimeKey(deckType.name);
    return MyHive.box2.put(key, date);
  }
}
