import 'package:duel_links_meta/http/http.dart';
import 'package:get/get.dart';

class WorldApi extends Net {
  Future<Response<List>> list() => httpClient.get('/api/v1/worlds');
}
