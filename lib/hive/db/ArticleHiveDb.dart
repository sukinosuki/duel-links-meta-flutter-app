import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/Article.dart';

class ArticleHiveDb {
  factory ArticleHiveDb() {
    return _instance;
  }

  ArticleHiveDb._constructor();

  static final _instance = ArticleHiveDb._constructor();

  String _getKey(String category) {
    return 'article:$category';
  }

  String _getExpireTimeKey(String category) {
    return 'article_expire:$category';
  }

  Future<List<Article>?> get(String category) async {
    final key = _getKey(category);
    List<Article>? articles;

    try {
      final data = await MyHive.box2.get(key) as List<dynamic>?;
      articles = data?.map((e) => e as Article).toList();
    } catch (e) {
      log('转换失败: $e');
      return null;
    }

    return articles;
  }

  Future<DateTime?>? getExpireTime(String category) async {
    final key = _getExpireTimeKey(category);
    DateTime? time;
    try {
      time = await MyHive.box2.get(key) as DateTime?;
    } catch (e) {
      log('转换失败: $e');
      return null;
    }

    return time;
  }

  Future<void> set(List<Article> articles, String category) {
    final key = _getKey(category);

    return MyHive.box2.put(key, articles);
  }

  Future<void> setExpireTime(DateTime? time, String category) {
    final key = _getExpireTimeKey(category);

    return MyHive.box2.put(key, time);
  }
}
