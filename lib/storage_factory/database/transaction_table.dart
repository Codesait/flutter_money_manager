import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
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

  Future<List<MyTransaction>> getAllByFilter(
      TransactionFilterType transactionFilterType) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    String filter;
    switch (transactionFilterType) {
      case TransactionFilterType.ALL:
        {
          break;
        }
      case TransactionFilterType.DAILY:
        {
          filter = '%Y-%m-%d %H:%M:%S.%s';
          break;
        }
      case TransactionFilterType.MONTHLY:
        {
          filter = '%Y-%m';
          break;
        }
      case TransactionFilterType.YEARLY:
        {
          filter = '%Y';
          break;
        }
    }

    String rawQuery = 'SELECT $id,'
        ' $date,'
        ' SUM($amount) $amount,'
        ' $description,'
        ' ${CategoryTable().id},'
        ' ${CategoryTable().color},'
        ' ${CategoryTable().name},'
        ' ${CategoryTable().type}'
        ' FROM $tableName'
        ' LEFT JOIN ${CategoryTable().tableName}'
        ' ON $category=${CategoryTable().id}'
        ' GROUP BY $category';

    if (filter != null) {
      rawQuery += ', STRFTIME(\'$filter\', $date)'
          ' ORDER BY STRFTIME(\'$filter\', $date) DESC';
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(rawQuery);

    // Convert the List<Map<String, dynamic> into a List<MyTransaction>.
    return List.generate(maps.length, (i) {
      return MyTransaction.fromMap(maps[i]);
    });
  }
}
