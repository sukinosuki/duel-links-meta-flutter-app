import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:get/get.dart';

class CardApi extends Net {
  Future<Response<List<MdCard>>> getByIds(String ids) => httpClient.get(
        '/api/v1/cards?_id[\$in]=$ids',
        decoder: (data) => (data as List<dynamic>).map(MdCard.fromJson).toList(),
      );

  Future<Response<MdCard>> getById(String id) => httpClient.get(
        '/api/v1/cards?_id[\$in]=$id&limit=1',
        decoder: MdCard.fromJson,
      );

  Future<Response<List<MdCard>>> getByObtainSource(String sourceId) => httpClient.get(
        '/api/v1/cards?obtain.source=$sourceId&sort=-rarity&limit=0',
        decoder: (data) => (data as List<dynamic>).map(MdCard.fromJson).toList(),
      );

  Future<Response<List<MdCard>>> list(Map<String, String>? params) => httpClient.get(
        '/api/v1/cards',
        query: params,
        decoder: (data) => (data as List<dynamic>).map(MdCard.fromJson).toList(),
      );
}
