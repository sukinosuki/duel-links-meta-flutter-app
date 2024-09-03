import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/MdCard.dart';

class CardHiveDb {
  static String _getKey(String id) {
    return 'card:$id';
  }

  static Future<MdCard?> get(String id) async {
    final key = _getKey(id);

    MdCard? card;
    try {
      card = await MyHive.box2.get(key) as MdCard?;
    } catch (e) {
      return null;
    }

    return card;
  }

  static Future<void> setCard(MdCard card) async {
    final key = _getKey(card.oid);

    return MyHive.box2.put(key, card);
  }
}
