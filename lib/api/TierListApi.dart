import 'package:duel_links_meta/api/http.dart';
import 'package:duel_links_meta/type/deck_type/TierList_PowerRanking.dart';
import 'package:duel_links_meta/type/tier_list_top_tier/TierList_TopTier.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class TierListApi {
  factory TierListApi() {
    return _instance;
  }

  TierListApi._constructor();

  static final TierListApi _instance = TierListApi._constructor();

  Future<Response<List<TierList_TopTier>>> getTopTiers() => http.get(
        r'/api/v1/deck-types?tier[$in]=0,1,2,3,4&limit=0&sort=name&fields=name,tier',
        decoder: (data) => (data as List<dynamic>).map(TierList_TopTier.fromJson).toList(),
      );

  Future<Response<List<TierList_PowerRanking>>> getPowerRankings() => http.get(
        r'/api/v1/deck-types?rush[$ne]=true&tournamentPower[$gte]=6&limit=0&sort=-tournamentPower&fields=name,tournamentPower,tournamentPowerTrend',
        decoder: (data) => (data as List<dynamic>).map(TierList_PowerRanking.fromJson).toList(),
      );

  Future<Response<List<TierList_PowerRanking>>> getRushRankings() => http.get(
        r'/api/v1/deck-types?rush=true&tournamentPower[$gte]=6&limit=0&sort=-tournamentPower&fields=name,tournamentPower,tournamentPowerTrend,rush',
        decoder: (data) => (data as List<dynamic>).map(TierList_PowerRanking.fromJson).toList(),
      );
}
