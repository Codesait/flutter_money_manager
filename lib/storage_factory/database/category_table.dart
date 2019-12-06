import 'package:flutter_money_manager/models/category.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class CategoryTable {
  final tableName = 'category_table';
  final id = 'category_id';
  final order = 'category_order';
  final color = 'category_color';
  final name = 'category_name';
  final type = 'transaction_type';

  void onCreate(Database db, int version) {
    db.execute('CREATE TABLE $tableName('
        '$id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$order INTEGER NOT NULL UNIQUE,'
        '$color INTEGER NOT NULL,'
        '$name TEXT NOT NULL UNIQUE,'
        '$type INTEGER NOT NULL)');
  }

  Future<int> insert(Category category) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    String sql = 'INSERT INTO $tableName($order, $color, $name, $type)'
        ' VALUES((SELECT (IFNULL(MAX($order), 0)+1) $order FROM $tableName),'
        ' ${category.color.value},'
        ' "${category.name}",'
        ' ${category.transactionType.value})';

    // Insert the Category into the correct table.
    return db.rawInsert(sql);
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

  Future<int> delete(int categoryId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    return db.delete(tableName, where: id + '=?', whereArgs: [categoryId]);
  }

  Future<int> update(Category category) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Update the correct category.
    return db.update(
      tableName,
      category.toMap(),
      // Ensure that the category has a matching id.
      where: "$id=?",
      // Pass the category's id as a whereArg to prevent SQL injection.
      whereArgs: [category.id],
    );
  }
}
