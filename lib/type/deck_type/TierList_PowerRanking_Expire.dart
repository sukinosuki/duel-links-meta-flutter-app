import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/deck_type/TierList_PowerRanking.dart';
import 'package:hive/hive.dart';

part 'TierList_PowerRanking_Expire.g.dart';

@HiveType(typeId: MyHive.tier_list_power_ranking_expire)
class TierList_PowerRanking_Expire {
  @HiveField(0)
  DateTime expire;

  @HiveField(1)
  List<TierList_PowerRanking> data;


  TierList_PowerRanking_Expire({required this.data, required this.expire});
}