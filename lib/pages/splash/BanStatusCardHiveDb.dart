import 'package:duel_links_meta/hive/MyHive.dart';

class BanStatusCardHiveDb {
  static const _banStatusCardIdsKey = 'ban_status:card_ids';
  static const _banStatusCardIdsFetchDateKey = 'ban_status:card_ids_refresh_date';

  static Future<List<String>?> getCardIds() async {
    List<String>? cardIds;
    try {
      cardIds = await MyHive.box2.get(_banStatusCardIdsKey) as List<String>?;
    } catch (e) {
      return null;
    }

    return cardIds;
  }

  static Future<DateTime?> getExpireTime() async {
    DateTime? expireTime;
    try {
      expireTime = await MyHive.box2.get(_banStatusCardIdsFetchDateKey) as DateTime?;
    } catch (e) {
      return null;
    }

    return expireTime;
  }

  static Future<void> setCardIds(List<String> ids) {
    return MyHive.box2.put(_banStatusCardIdsKey, ids);
  }

  static Future<void> setExpireTime(DateTime expireTime) {
    return MyHive.box2.put(_banStatusCardIdsFetchDateKey, expireTime);
  }
}
