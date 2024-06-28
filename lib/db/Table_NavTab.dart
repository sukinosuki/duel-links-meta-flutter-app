
import 'package:duel_links_meta/db/index.dart';
import 'package:sqflite/sqflite.dart';

class Table_NavTab {

  static Table_NavTab? _instance;

  static Table_NavTab _getInstance() {

    _instance ??= Table_NavTab();

    return _instance!;
  }

  static Table_NavTab get instance => _getInstance();

  var table = 'nav_tab';

  Future<int> insert(Map<String, dynamic> data) {
    return Db.db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> delete() {
    return Db.db.delete(table);
  }

  Future<List<Map<String, dynamic>>> query() {
    return Db.db.query(table);
  }
}
