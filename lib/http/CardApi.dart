import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:get/get.dart';

class CardApi extends Net {
  Future<Response<List<MdCard>>> getById(String ids) => httpClient.get('/api/v1/cards?_id[\$in]=$ids',

  decoder: (data) => (data as List<dynamic>).map(MdCard.fromJson).toList());

  Future<Response<List>> getObtainSourceId(String sourceId) => httpClient.get('/api/v1/cards?obtain.source=$sourceId&sort=-rarity&limit=0');

  Future<Response<List>> list(Map<String, String>? params) => httpClient.get('/api/v1/cards', query: params);
}
