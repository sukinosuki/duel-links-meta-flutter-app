import 'package:duel_links_meta/http/http.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class DeckTypeApi extends Net {

  Future<Response<List>> getTopTiers() =>
      httpClient.get('/api/v1/deck-types?tier[\$in]=0,1,2,3,4&limit=0&sort=name&fields=name,tier');

  Future<Response<List>> getPowerRankings() => httpClient.get(
      '/api/v1/deck-types?rush[\$ne]=true&tournamentPower[\$gte]=6&limit=0&sort=-tournamentPower&fields=name,tournamentPower,tournamentPowerTrend');

  Future<Response<List>> getRushRankings() => httpClient.get(
      '/api/v1/deck-types?rush=true&tournamentPower[\$gte]=6&limit=0&sort=-tournamentPower&fields=name,tournamentPower,tournamentPowerTrend,rush');
}
