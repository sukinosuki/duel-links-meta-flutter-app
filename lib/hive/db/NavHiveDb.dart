import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/NavTab.dart';

class HomeHiveDb {
   factory HomeHiveDb(){
     return _instance;
   }

   HomeHiveDb._constructor();
   static final HomeHiveDb _instance = HomeHiveDb._constructor();

   final String _navTabKey = 'nav_tab:list';
   final String _navTabFetchDateKey = 'nav_tab:fetch_date';

   Future<List<NavTab>?> getNavTabList() async {
    final hiveData = await MyHive.box.get(_navTabKey) as List?;

    if (hiveData == null) return null;

    try {
      return hiveData.cast<NavTab>();
    } catch (e) {
      return null;
    }
  }

   Future<void> deleteNavTabList() {
    return MyHive.box.delete(_navTabKey);
  }

   Future<void> deleteNavTabListExpireTime() {
    return MyHive.box.delete(_navTabFetchDateKey);
  }

   Future<DateTime?> getNavTabListExpireTime() async {
    final expireTime = await MyHive.box.get(_navTabFetchDateKey) as DateTime?;

    return expireTime;
  }

   Future<void> setNavTabList(List<NavTab>? data) {
    return MyHive.box.put(_navTabKey, data);
  }

   Future<void> setNavTabListExpireTime(DateTime? time) {
    return MyHive.box.put(_navTabFetchDateKey, time);
  }
}
