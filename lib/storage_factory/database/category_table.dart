import 'package:flutter_money_manager/models/category.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class CategoryTable {
  final String tableName = 'category_table';
  final String id = 'category_id';
  final String color = 'category_color';
  final String name = 'category_name';
  final String type = 'transaction_type';

  void onCreate(Database db, int version) {
    db.execute('CREATE TABLE $tableName('
        '$id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$color INTEGER,'
        '$name TEXT,'
        '$type INTEGER)');
  }

  void insert(Category category) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Insert the Category into the correct table. Also specify the
    // 'conflictAlgorithm'. In this case, if the same category is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      tableName,
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Category>> getAll() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all The Categories.
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    // Convert the List<Map<String, dynamic> into a List<Category>.
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }
}
