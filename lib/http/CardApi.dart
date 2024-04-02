import 'package:duel_links_meta/http/http.dart';
import 'package:get/get.dart';

class CardApi extends Net {
  Future<Response<List>> getById(String ids) => httpClient.get('/api/v1/cards?_id[\$in]=$ids');

  Future<Response<List>> getObtainSourceId(String sourceId) => httpClient.get('/api/v1/cards?obtain.source=$sourceId&sort=-rarity&limit=0');

  Future<Response<List>> list(Map<String, String>? params) => httpClient.get('/api/v1/cards', query: params);
}
