import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/NavTab.dart';
import 'package:duel_links_meta/type/ban_list_change/BanListChange.dart';
import 'package:duel_links_meta/type/ban_list_change/BanStatusCard.dart';
import 'package:duel_links_meta/type/deck_type/DeckType.dart';
import 'package:duel_links_meta/type/deck_type/TierList_PowerRanking_Expire.dart';
import 'package:duel_links_meta/type/deck_type/TierList_PowerRanking.dart';
import 'package:duel_links_meta/type/pack_set/ExpireData.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:duel_links_meta/type/tier_list_top_tier/TierList_TopTier.dart';
import 'package:duel_links_meta/type/tier_list_top_tier/TierList_TopTier_Expire.dart';
import 'package:hive_flutter/adapters.dart';

const boxName = 'todo_box';
const boxName2 = 'todo_box2';

class MyHive {
  static const int tier_list_top_tier = 1;
  static const int tier_list_power_ranking = 2;
  static const int tier_list_top_tier_expire = 3;
  static const int tier_list_power_ranking_expire = 4;
  static const int pack_set = 5;
  static const int pack_set_icon = 6;
  static const int md_card = 7;
  static const int ban_list_chnage = 8;
  static const int ban_list_chnage_changes = 9;
  static const int ban_list_chnage_changes_card = 10;
  static const int ban_status_card = 11;
  static const int nav_tab = 12;
  static const int deck_type = 13;
  static const int deck_type_deck_breakdown = 14;
  static const int deck_type_deck_breakdown_skill = 15;
  static const int deck_type_deck_breakdown_card = 16;

  // static const int expire_data = 10;

  // static late Box<List<TierList_TopTier>> box;
  static late Box box;
  static late LazyBox box2;

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
      ..registerAdapter(MdCardAdapter())
      ..registerAdapter(BanListChangeAdapter())
      ..registerAdapter(BanListChangeChangeAdapter())
      ..registerAdapter(BanListChangeChangeCardAdapter())
      ..registerAdapter(BanStatusCardAdapter())
      ..registerAdapter(NavTabAdapter())
      ..registerAdapter(DeckTypeAdapter())
      ..registerAdapter(DeckTypeDeckBreakdownAdapter())
      ..registerAdapter(DeckTypeDeckBreakdownSkillAdapter())
      ..registerAdapter(DeckTypeDeckBreakdownCardsAdapter());
    // Hive.registerAdapter(TLoginFormAdapter());
    box = await Hive.openBox(boxName);
    box2 = await Hive.openLazyBox(boxName2);
  }
}
