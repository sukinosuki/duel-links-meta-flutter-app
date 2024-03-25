import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:get/get.dart';

class ArticleApi extends Net {
  Future<Response<List<dynamic>>> list(Map<String, String> _params) {
    var params = <String, dynamic>{};
    params['limit'] = _params['limit'] ?? '8';
    params['page'] = _params['page'];

    params['field'] = '-markdown';
    params['sort'] = '-featured,-date';
    params['hidden[\$ne]'] = 'true';
    params['category[\$ne]'] = 'quick-news';

    return httpClient.get('/api/v1/articles', query: params);
  }
}
