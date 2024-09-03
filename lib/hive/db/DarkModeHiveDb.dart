import 'package:flutter/material.dart';

import '../MyHive.dart';

class DarkModeHiveDb {
  static const String _key = 'dark_mode';

  static void set() {
    return MyHive.box2.put(_key, 'light').ignore();
  }

  static Future<ThemeMode> get() async {
    final mode = await MyHive.box2.get('dark_mode');

    if (mode == 'dark') {
      return ThemeMode.dark;
    }

    if (mode == 'system') {
      return ThemeMode.system;
    }

    return ThemeMode.light;
  }
}
