import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:duel_links_meta/type/top_deck/TopDeckSimple.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class TopDeckApi extends Net {
  Future<Response<TopDeck>> getBreakdownSample(Map<String, String> params) =>
      httpClient.get('/api/v1/top-decks', query: params, decoder: TopDeck.fromJson);

  // Future<Response<List>> list(Map<String,dynamic> params) =>
  //     httpClient.get('/api/v1/top-decks', query: params);
  Future<Response<List<TopDeck>>> list(Map<String, dynamic> params) => httpClient.get('/api/v1/top-decks', query: params, decoder: (data) {
        // return (data as List<dynamic>).map(TopDeckSimple.fromJson).toList();
        return (data as List<dynamic>).map(TopDeck.fromJson).toList();
      });
}
