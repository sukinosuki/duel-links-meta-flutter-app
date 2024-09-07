import 'package:duel_links_meta/hive/MyHive.dart';
import 'package:flutter/material.dart';

class DarkModeHiveDb {

  factory DarkModeHiveDb() {
    return _instance;
  }

  DarkModeHiveDb._constructor();

  static final DarkModeHiveDb _instance = DarkModeHiveDb._constructor();

   final String _key = 'dark_mode';

   void set(ThemeMode mode) {

    return MyHive.box.put(_key, mode.name).ignore();
  }

   Future<ThemeMode> get() async {
    final mode = await MyHive.box.get(_key);

    if (mode == ThemeMode.dark.name) {
      return ThemeMode.dark;
    }

    if (mode == ThemeMode.system.name) {
      return ThemeMode.system;
    }

    return ThemeMode.light;
  }
}
