import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:get/get.dart';

class ArticleApi extends Net {
  Future<Response<List<Article>>> articleList(Map<String, String> _params) {
    final params = <String, dynamic>{};
    params['limit'] = _params['limit'] ?? '8';
    params['page'] = _params['page'];

    params['field'] = '-markdown';
    params['sort'] = '-featured,-date';
    params[r'hidden[$ne]'] = 'true';
    params[r'category[$ne]'] = 'quick-news';

    return httpClient.get('/api/v1/articles', query: params, decoder: (data) => (data as List<dynamic>).map(Article.fromJson).toList());
  }

  Future<Response<List<Article>>> activeEventLst(DateTime countdownDate) {
    return httpClient.get(
      '/api/v1/articles?category=event&countdownDate[\$gte]=$countdownDate&sort=-date&hidden[\$ne]=true&limit=10',
      decoder: (data) => (data as List<dynamic>).map(Article.fromJson).toList(),
    );
  }

  Future<Response<List<Article>>> pastEventLst(DateTime countdownDate, int page) {
    return httpClient.get(
      '/api/v1/articles?category=event&countdownDate[\$lt]=$countdownDate&sort=-date&hidden[\$ne]=true&limit=10&page=$page',
      decoder: (data) => (data as List<dynamic>).map(Article.fromJson).toList(),
    );
  }

  Future<Response<List<Article>>> pinnedFarmingEvent() {
    return httpClient.get(
      r'/api/v1/articles?category=farming&subCategory=pinned&sort=-date&hidden[$ne]=true',
      decoder: (data) => (data as List<dynamic>).map(Article.fromJson).toList(),
    );
  }
}
