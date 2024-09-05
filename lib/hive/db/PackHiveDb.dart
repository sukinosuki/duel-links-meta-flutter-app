import 'package:duel_links_meta/hive/MyHive.dart';

class PackHiveDb {
  factory PackHiveDb() {
    return _instance;
  }

  PackHiveDb._constructor();

  static final _instance = PackHiveDb._constructor();

  String _getKey(String packId) {
    return 'pack_card_ids:$packId';
  }

   Future<List<String>?>? getIds(String packId) async {
    final key = _getKey(packId);

    List<String>? ids;
    try {
      ids = await MyHive.box2.get(key) as List<String>?;
    } catch (e) {
      return null;
    }

    return ids;
  }

   Future<void> setIds(String packId, List<String> ids) {
    final key = _getKey(packId);

    return MyHive.box2.put(key, ids);
  }
}
