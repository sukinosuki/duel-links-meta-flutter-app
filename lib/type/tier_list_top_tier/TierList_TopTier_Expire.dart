import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/tier_list_top_tier/TierList_TopTier.dart';
import 'package:hive/hive.dart';

part 'TierList_TopTier_Expire.g.dart';

@HiveType(typeId: MyHive.tier_list_top_tier_expire)
class TierList_TopTier_Expire {
  @HiveField(0)
  DateTime expire;

  @HiveField(1)
  List<TierList_TopTier> data;

  TierList_TopTier_Expire({required this.data, required this.expire});
}