import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  static late Database db;

  static init() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'duel_links_meta.db'),
      onCreate: (db, version) async{
        await db.execute('CREATE TABLE IF NOT EXISTS nav_tab(id INTEGER PRIMARY KEY, _id TEXT, image TEXT, title TEXT)');
      },
      version: 2,
    );

    db = await database;
  }

  static deleteDatabase() {
    databaseFactory.deleteDatabase('duel_links_meta.db');
  }
}
