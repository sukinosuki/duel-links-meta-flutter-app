import 'package:duel_links_meta/api/http.dart';
import 'package:get/get_connect/connect.dart';

class SkillStatsApi {
  factory SkillStatsApi() {
    return _instance;
  }

  SkillStatsApi._constructor();

  static final _instance = SkillStatsApi._constructor();

  Future<Response<List<dynamic>>> getByName(String name) => http.get('/api/v1/skills/stats?name=$name');
}
