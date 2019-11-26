import 'package:flutter_money_manager/models/total.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class TransactionTable {
  final tableName = 'transaction_table';
  final id = 'transaction_id';
  final date = 'transaction_date';
  final amount = 'transaction_amount';
  final description = 'transaction_description';
  final category = 'transaction_category';

  void onCreate(Database db, int version) {
    db.execute('CREATE TABLE $tableName('
        '$id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$date TEXT,'
        '$amount REAL,'
        '$description TEXT,'
        '$category INTEGER)');
  }

  Future<int> insert(MyTransaction transaction) async {
    // Checking backend validation
    transaction.checkValidationAndThrow();

    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Insert the TransactionModel into the table. Also specify the 'conflictAlgorithm'.
    // In this case, if the same category is inserted multiple times, it replaces the previous data.
    return await db.insert(
      tableName,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<MyTransaction>> getAll() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all the records.
    String rawQuery = 'SELECT * FROM $tableName'
        ' LEFT JOIN ${CategoryTable().tableName}'
        ' ON $category=${CategoryTable().id}'
        ' ORDER BY $date DESC';
    final List<Map<String, dynamic>> maps = await db.rawQuery(rawQuery);

    // Convert the List<Map<String, dynamic> into a List<MyTransaction>.
    return List.generate(maps.length, (i) {
      return MyTransaction.fromMap(maps[i]);
    });
  }

  Future<List<Total>> getTotals() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for total amount that group up with category.
    String rawQuery = 'SELECT ${CategoryTable().type}, SUM($amount) $amount'
        ' FROM $tableName'
        ' INNER JOIN ${CategoryTable().tableName}'
        ' ON $category=${CategoryTable().id}'
        ' GROUP BY ${CategoryTable().type}';
    final List<Map<String, dynamic>> maps = await db.rawQuery(rawQuery);

    // Convert the List<Map<String, dynamic> into a List<Total>.
    return List.generate(maps.length, (index) {
      return Total.fromMap(maps[index]);
    });
  }

  Future<int> delete(int transactionId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    return db.delete(tableName, where: id + '=?', whereArgs: [transactionId]);
  }

  Future<bool> isCategoryExist(String categoryId) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    final List<Map<String, dynamic>> map = await db.rawQuery('select $category'
        ' from $tableName'
        ' where $category="$categoryId"'
        ' limit 1');

    return map.length > 0;
  }
}
