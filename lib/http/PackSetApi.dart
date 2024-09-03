import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:get/get.dart';

class PackSetApi extends Net {
  Future<Response<List<PackSet>>> list() => httpClient.get(
        '/api/v1/sets?sort=-release&limit=0',
        decoder: (data) => (data as List<dynamic>).map(PackSet.fromJson).toList(),
      );
}
