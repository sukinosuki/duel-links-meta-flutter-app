import 'package:duel_links_meta/http/http.dart';
import 'package:get/get.dart';

class CardApi extends Net {
  Future<Response<List>> getById(String ids) => httpClient.get('/api/v1/cards?_id[\$in]=$ids');
}
