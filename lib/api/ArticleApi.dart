import 'package:duel_links_meta/api/http.dart';
import 'package:duel_links_meta/type/Article.dart';
import 'package:get/get.dart';

class ArticleApi {
  factory ArticleApi() {
    return _instance;
  }

  ArticleApi._constructor();

  static final _instance = ArticleApi._constructor();

  Future<Response<List<Article>>> articleList(Map<String, String> params) {
    return http.get(
      '/api/v1/articles',
      query: params,
      decoder: (data) => (data as List<dynamic>).map(Article.fromJson).toList(),
    );
  }

  Future<Response<List<Article>>> activeEventLst(DateTime countdownDate) {
    return http.get(
      '/api/v1/articles?category=event&countdownDate[\$gte]=$countdownDate&sort=-date&hidden[\$ne]=true&limit=10',
      decoder: (data) => (data as List<dynamic>).map(Article.fromJson).toList(),
    );
  }

  Future<Response<List<Article>>> pastEventLst(DateTime countdownDate, int page) {
    return http.get(
      '/api/v1/articles?category=event&countdownDate[\$lt]=$countdownDate&sort=-date&hidden[\$ne]=true&limit=10&page=$page',
      decoder: (data) => (data as List<dynamic>).map(Article.fromJson).toList(),
    );
  }

  Future<Response<List<Article>>> pinnedFarmingEvent() {
    return http.get(
      r'/api/v1/articles?category=farming&subCategory=pinned&sort=-date&hidden[$ne]=true',
      decoder: (data) => (data as List<dynamic>).map(Article.fromJson).toList(),
    );
  }
}
