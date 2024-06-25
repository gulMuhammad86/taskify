import 'package:sqflite/sqflite.dart';
import 'package:taskify/repository/database_connection.dart';

class Repositoy {
  final DatabaseConnection _databaseConnection;

  Repositoy() : _databaseConnection = DatabaseConnection();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _databaseConnection.openDataBase();
    return _database!;
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteCategory(table, itemId) async {
    var connection = await database;
    return await connection.delete(table, where: 'id=?', whereArgs: [itemId]);
  }

  getItemByID(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  savTodo(table, data) async {
    var connection = await database;
    return await connection.insert(table, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  readTodoData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  readTodoByCategory(table, coulonName, coulomValue) async {
    var connection = await database;
    return await connection
        .query(table, where: '$coulonName=?', whereArgs: [coulomValue]);
  }
}
