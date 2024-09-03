import 'dart:developer';

import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:duel_links_meta/type/skill/Skill.dart';
import 'package:get/get.dart';

class SkillHiveDb {
  static String _getKey(String skillName) {
    return 'skill:$skillName';
  }

  static String _getExpireTimeKey(String skillName) {
    return 'skill_expire_time:$skillName';
  }

  static Future<Skill?>? get(String skillName) async {
    final key = _getKey(skillName);

    Skill? skill;
    try {
      skill = await MyHive.box2.get(key) as Skill?;
    } catch (e) {
      log('转换失败 $e');
      return null;
    }

    return skill;
  }

  static Future<DateTime?>? getExpireTime(String skillName) async {
    final key = _getExpireTimeKey(skillName);
    DateTime? time;
    try {
      time = await MyHive.box2.get(key) as DateTime?;
    } catch (e) {
      log('转换失败 $e');
      return null;
    }

    return time;
  }

  static Future<void> set(Skill skill) {
    final key = _getKey(skill.name);
    return MyHive.box2.put(key, skill);
  }

  static Future<void> setExpireTime(String skillName, DateTime time) {
    final key = _getExpireTimeKey(skillName);

    return MyHive.box2.put(key, time);
  }
}
