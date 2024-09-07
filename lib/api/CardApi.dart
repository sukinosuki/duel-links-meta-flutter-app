import 'package:duel_links_meta/api/http.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:get/get.dart';

class CardApi {
  factory CardApi() {
    return _instance;
  }

  CardApi._constructor();

  static final _instance = CardApi._constructor();

  Future<Response<List<MdCard>>> getByIds(String ids) => http.get(
        '/api/v1/cards?_id[\$in]=$ids',
        decoder: (data) => (data as List<dynamic>).map(MdCard.fromJson).toList(),
      );

  Future<Response<MdCard>> getById(String id) => http.get(
        '/api/v1/cards?_id[\$in]=$id&limit=1',
        decoder: MdCard.fromJson,
      );

  Future<Response<List<MdCard>>> getByObtainSource(String sourceId) => http.get(
        '/api/v1/cards?obtain.source=$sourceId&sort=-rarity&limit=0',
        decoder: (data) => (data as List<dynamic>).map(MdCard.fromJson).toList(),
      );

  Future<Response<List<MdCard>>> list(Map<String, String>? params) => http.get(
        '/api/v1/cards',
        query: params,
        decoder: (data) => (data as List<dynamic>).map(MdCard.fromJson).toList(),
      );
}
