import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage_DarkMode {
  static const String _key = 'app.setting.dark_mode';

  static Future<bool> save(String value) {
    return StringLocalStorage.save(_key, value);
  }

  static Future<String?> get() {
    return StringLocalStorage.get(_key);
  }

  static Future<bool> remove() {
    return StringLocalStorage.remove(_key);
  }
}

class StringLocalStorage {
  static Future<bool> save(String key, String value) async {
    var sp = await SharedPreferences.getInstance();

    return sp.setString(key, value);
  }

  static Future<String?> get(String key) async {
    var sp = await SharedPreferences.getInstance();

    return sp.getString(key);
  }

  static Future<bool> remove(String key) async {
    var sp = await SharedPreferences.getInstance();

    return sp.remove(key);
  }
}
