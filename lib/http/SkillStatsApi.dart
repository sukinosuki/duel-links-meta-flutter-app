import 'package:duel_links_meta/http/http.dart';
import 'package:get/get_connect/connect.dart';

class SkillStatsApi extends Net {
  Future<Response<List>> getByName(String name) => httpClient.get('/api/v1/skills/stats?name=$name');
}
