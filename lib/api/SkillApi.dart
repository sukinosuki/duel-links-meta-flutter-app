import 'package:duel_links_meta/api/http.dart';
import 'package:duel_links_meta/type/skill/Skill.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class SkillApi {
  factory SkillApi() {
    return _instance;
  }

  SkillApi._constructor();

  static final _instance = SkillApi._constructor();

  Future<Response<Skill>> getByName(String name) => http.get(
        '/api/v1/skills?name[\$in]=$name&limit=1',
        decoder: Skill.fromJson,
      );

  Future<Response<List<dynamic>>> getByCharacterId(String characterId) =>
      http.get('/api/v1/skills?characters.character[\$or]=$characterId&archive[\$or]=true&rush[\$ne]=true&sort=name');
}
