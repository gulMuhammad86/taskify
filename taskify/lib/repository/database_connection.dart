import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  openDataBase() async {
    var drictory = await getApplicationDocumentsDirectory();
    var path = join(drictory.path, 'db_taskify_todolist');
    var database =
        await openDatabase(path, version: 1, onCreate: onCreatingDatabase);

    return database;
  }

  onCreatingDatabase(Database database, int version) async {
    await database.execute(
        'CREATE  TABLE categories (id INTEGER PRIMARY KEY, name TEXT, description TEXT)');

    await database.execute(
        'CREATE TABLE todo (id INTEGER PRIMARY KEY, name TEXT, description TEXT,category TEXT, date TEXT,isfinished INTEGER)');
  }
}
