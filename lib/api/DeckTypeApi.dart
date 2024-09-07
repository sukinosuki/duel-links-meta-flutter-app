import 'package:duel_links_meta/type/deck_type/DeckType.dart';
import 'package:get/get_connect/http/src/response/response.dart';

import 'package:duel_links_meta/api/http.dart';

class DeckTypeApi{
  factory DeckTypeApi() {
    return _instance;
  }

  DeckTypeApi._constructor();

  static final _instance = DeckTypeApi._constructor();

  Future<Response<DeckType>> getDetailByName(String name) =>
      http.get('/api/v1/deck-types?name=$name&limit=1&aggregate=aboveThresh', decoder: DeckType.fromJson);
}
