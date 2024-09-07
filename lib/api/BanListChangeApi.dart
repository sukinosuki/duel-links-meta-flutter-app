import 'package:duel_links_meta/api/http.dart';
import 'package:duel_links_meta/type/ban_list_change/BanListChange.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class BanListChangeApi  {
  factory BanListChangeApi() {
    return _instance;
  }

  BanListChangeApi._constructor();

  static final _instance = BanListChangeApi._constructor();

  Future<Response<List<BanListChange>>> list({Map<String, String>? params}) => http.get(
        '/api/v1/banlist-changes',
        query: params,
        decoder: (data) => (data as List<dynamic>).map(BanListChange.fromJson).toList(),
      );
}
