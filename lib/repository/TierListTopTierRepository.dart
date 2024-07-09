import '../hive/MyHive.dart';
import '../type/tier_list_top_tier/TierList_TopTier.dart';

class TierListTopTierRepository {


  static Future<List<TierList_TopTier>?> get() async {
    var list = <TierList_TopTier>[];
    print('[fetchTopTiers] 从box取值开始');

    const hiveBoxKey = 'tier_list:top_tier';
    // if (!force) {
    var hiveValue = await MyHive.box2.get(hiveBoxKey);
    print('[fetchTopTiers] box取值，value: $hiveValue, value == null ${hiveValue == null}, value type: ${hiveValue.runtimeType}');
    // }

    if (hiveValue == null){
      return null;
    }



  }

}