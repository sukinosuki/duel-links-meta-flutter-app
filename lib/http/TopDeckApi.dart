import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class TopDeckApi extends Net {
  Future<Response<TopDeck>> getBreakdownSample(String deckTypeId) => httpClient
      .get('/api/v1/top-decks?deckType=$deckTypeId&fields=-_id,-__v&sort=-tournamentType,-created&created[\$gte]=(days-60)&limit=1', decoder: TopDeck.fromJson);
}
