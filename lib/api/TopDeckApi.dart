import 'package:duel_links_meta/api/http.dart';
import 'package:duel_links_meta/type/top_deck/TopDeck.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class TopDeckApi {
  factory TopDeckApi() {
    return _instance;
  }

  TopDeckApi._constructor();

  static final _instance = TopDeckApi._constructor();

  Future<Response<TopDeck>> getBreakdownSample(Map<String, String> params) =>
      http.get('/api/v1/top-decks', query: params, decoder: TopDeck.fromJson);

  Future<Response<List<TopDeck>>> list(Map<String, dynamic> params) => http.get(
        '/api/v1/top-decks',
        query: params,
        decoder: (data) {
          return (data as List<dynamic>).map(TopDeck.fromJson).toList();
        },
      );
}
