import 'package:duel_links_meta/http/http.dart';
import 'package:get/get.dart';

class NavTabApi extends Net {
  Future<Response<List>> list() => httpClient.get('/api/v1/nav-tabs');

  // Future<Response> getTierListChangesLatestDate() => httpClient.get('/api/v1/tierlist-changes?fields=-_id,date&sort=-date&limit=1');
}
