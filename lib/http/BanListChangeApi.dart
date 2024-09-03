import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/ban_list_change/BanListChange.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class BanListChangeApi extends Net {
  Future<Response<List<BanListChange>>> list({Map<String, String>? params}) => httpClient.get(
        '/api/v1/banlist-changes',
        query: params,
        decoder: (data) => (data as List<dynamic>).map(BanListChange.fromJson).toList(),
      );
}
