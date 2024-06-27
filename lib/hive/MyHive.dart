import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/deck_type/TierList_PowerRanking_Expire.dart';
import 'package:duel_links_meta/type/deck_type/TierList_PowerRanking.dart';
import 'package:duel_links_meta/type/pack_set/ExpireData.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:duel_links_meta/type/tier_list_top_tier/TierList_TopTier.dart';
import 'package:duel_links_meta/type/tier_list_top_tier/TierList_TopTier_Expire.dart';
import 'package:hive_flutter/adapters.dart';

const boxName = 'todo_box';

class MyHive {
  static const int tier_list_top_tier = 1;
  static const int tier_list_power_ranking = 2;
  static const int tier_list_top_tier_expire = 3;
  static const int tier_list_power_ranking_expire = 4;
  static const int pack_set = 5;
  static const int pack_set_icon = 6;
  static const int md_card = 7;

  // static const int expire_data = 10;

  // static late Box<List<TierList_TopTier>> box;
  static late Box box;

  MyHive._();

  static init() async {
    await Hive.initFlutter();

    Hive
      ..registerAdapter(TierListTopTierAdapter())
      ..registerAdapter(TierListTopTierExpireAdapter())
      ..registerAdapter(TierListPowerRankingExpireAdapter())
      ..registerAdapter(TierListPowerRankingAdapter())
      ..registerAdapter(PackSetAdapter())
      ..registerAdapter(PackSetIconAdapter())
      ..registerAdapter(MdCardAdapter());

    // Hive.registerAdapter(TLoginFormAdapter());
    box = await Hive.openBox(boxName);
  }
}
