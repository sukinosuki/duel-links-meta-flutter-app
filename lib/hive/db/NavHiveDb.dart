import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/NavTab.dart';

class HomeHiveDb {
  List<NavTab>? navTabList;

  static const _navTabKey = 'nav_tab:list';
  static const _navTabFetchDateKey = 'nav_tab:fetch_date';

  static Future<List<NavTab>?> getNavTabList() async {
    final hiveData = await MyHive.box2.get(_navTabKey) as List?;

    if (hiveData == null) return null;

    try {
      return hiveData.cast<NavTab>();
    } catch (e) {
      return null;
    }
  }

  static Future<void> deleteNavTabList() {
    return MyHive.box2.delete(_navTabKey);
  }

  static Future<void> deleteNavTabListExpireTime() {
    return MyHive.box2.delete(_navTabFetchDateKey);
  }

  static Future<DateTime?> getNavTabListExpireTime() async {
    final expireTime = await MyHive.box2.get(_navTabFetchDateKey) as DateTime?;

    return expireTime;
  }

  static Future<void> setNavTabList(List<NavTab>? data) {
    return MyHive.box2.put(_navTabKey, data);
  }

  static Future<void> setNavTabListExpireTime(DateTime? time) {
    return MyHive.box2.put(_navTabFetchDateKey, time);
  }
}
