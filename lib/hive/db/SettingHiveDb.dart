import 'package:duel_links_meta/hive/MyHive.dart';

class SettingHiveDb {
  factory SettingHiveDb() => _instance;

  SettingHiveDb._constructor();

  static final _instance = SettingHiveDb._constructor();

  final String _showWebviewNavsKey = 'setting:show_webview_navs';
  final String _themeColorIndexKey = 'setting:theme_color_index';

  Future<void> setShowWebviewNavs({required bool show}) {
    return MyHive.box.put(_showWebviewNavsKey, show);
  }

  Future<bool?> getShowWebviewNavs() async {
    final value = await MyHive.box.get(_showWebviewNavsKey) as bool?;

    return value;
  }

  Future<void> setThemeColorIndex(int index) {
    return MyHive.box.put(_themeColorIndexKey, index);
  }

  Future<int?> getThemeColorIndex() async{
    return (await MyHive.box.get(_themeColorIndexKey)) as int?;
  }
}
