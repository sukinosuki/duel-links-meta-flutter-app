import 'package:duel_links_meta/http/http.dart';
import 'package:get/get.dart';

class PackSetApi extends Net {
  Future<Response<List>> list() => httpClient.get('/api/v1/sets?sort=-release&limit=0');
}