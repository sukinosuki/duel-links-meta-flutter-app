import 'package:duel_links_meta/http/http.dart';
import 'package:duel_links_meta/type/skill/Skill.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class SkillApi extends Net {
  
  // 获取技能列表
  Future<Response<Skill>> getSkills(String name) => httpClient.get('/api/v1/skills?name[\$in]=$name&limit=1', decoder: Skill.fromJson);
}