import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/deck_type/DeckType.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class DeckTypeApi extends Net {
  Future<Response<DeckType>> getDetailByName(String name) =>
      httpClient.get('/api/v1/deck-types?name=$name&limit=1&aggregate=aboveThresh', decoder: DeckType.fromJson);
}
