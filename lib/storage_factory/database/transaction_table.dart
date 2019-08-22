import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:sqflite/sqflite.dart';

import 'database_helper.dart';

class TransactionTable {
  final tableName = 'transactoin_table';
  final id = 'transaction_id';
  final date = 'transaction_date';
  final amount = 'transaction_amount';
  final description = 'transaction_description';
  final category = 'transaction_category';

  void onCreate(Database db, int version) {
    db.execute('CREATE TABLE $tableName('
        '$id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$date INTEGER,'
        '$amount REAL,'
        '$description TEXT,'
        '$category INTEGER)');

    print('$tableName is created successfully!');
  }

  void insert(MyTransaction transaction) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Insert the TransactionModel into the table. Also specify the 'conflictAlgorithm'.
    // In this case, if the same category is inserted multiple times, it replaces the previous data.
    await db.insert(
      tableName,
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    print('Transaction($transaction) is inserted successfully!');
  }

  Future<List<MyTransaction>> getAll() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Query the table for all the records.
    String rawQuery = 'SELECT * FROM $tableName'
        ' LEFT JOIN ${CategoryTable().tableName}'
        ' ON $category=${CategoryTable().id}';
    final List<Map<String, dynamic>> maps = await db.rawQuery(rawQuery);

    // Convert the List<Map<String, dynamic> into a List<MyTransaction>.
    return List.generate(maps.length, (i) {
      return MyTransaction.fromMap(maps[i]);
    });
  }
}
