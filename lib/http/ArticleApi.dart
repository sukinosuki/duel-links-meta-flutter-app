import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:get/get.dart';

class ArticleApi extends Net {
  Future<Response<List<dynamic>>> articleList(Map<String, String> _params) {
    var params = <String, dynamic>{};
    params['limit'] = _params['limit'] ?? '8';
    params['page'] = _params['page'];

    params['field'] = '-markdown';
    params['sort'] = '-featured,-date';
    params['hidden[\$ne]'] = 'true';
    params['category[\$ne]'] = 'quick-news';

    return httpClient.get('/api/v1/articles', query: params);
  }

  Future<Response<List<dynamic>>> activeEventLst(DateTime countdownDate) {
    return httpClient.get('/api/v1/articles?category=event&countdownDate[\$gte]=$countdownDate&sort=-date&hidden[\$ne]=true&limit=10');
  }

  Future<Response<List<dynamic>>> pastEventLst(DateTime countdownDate, int page) {
    return httpClient.get('/api/v1/articles?category=event&countdownDate[\$lt]=$countdownDate&sort=-date&hidden[\$ne]=true&limit=10&page=$page');
  }

  Future<Response<List<dynamic>>> pinnedFarmingEvent() {
    return httpClient.get('/api/v1/articles?category=farming&subCategory=pinned&sort=-date&hidden[\$ne]=true');
  }
}
