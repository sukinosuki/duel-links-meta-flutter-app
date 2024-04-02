
import 'package:duel_links_meta/http/http.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class BanListChangeApi extends Net {
  Future<Response<List>> list({Map<String, String>? params}) => httpClient.get('/api/v1/banlist-changes', query: params);
}