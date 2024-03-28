import 'package:duel_links_meta/http/http.dart';
import 'package:get/get.dart';

class CharacterApi extends Net {
  Future<Response<List>> list() => httpClient.get('/api/v1/characters?npc[\$ne]=true&limit=0&sort=-linkedArticle.date');
}
