import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/NavTab.dart';
import 'package:get/get.dart';

class NavTabApi extends Net {
  factory NavTabApi() {
    return _instance;
  }

  NavTabApi._privateConstructor();

  static final NavTabApi _instance = NavTabApi._privateConstructor();

  Future<Response<List<NavTab>>> list() => httpClient.get(
        '/api/v1/nav-tabs',
        decoder: (data) => (data as List<dynamic>).map(NavTab.fromJson).toList(),
      );
}
