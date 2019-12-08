import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:sqflite/sqflite.dart';
import 'package:meta/meta.dart';

import 'database_helper.dart';

class TransactionTable {
  final tableName = 'transaction_table';
  final id = 'transaction_id';
  final date = 'transaction_date';
  final amount = 'transaction_amount';
  final description = 'transaction_description';
  final category = 'transaction_category';
  final deleted = 'transaction_deleted';

  void onCreate(Database db, int version) {
    db.execute('CREATE TABLE $tableName('
        '$id INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$date TEXT NOT NULL,'
        '$amount REAL NOT NULL,'
        '$description TEXT,'
        '$category INTEGER NOT NULL,'
        '$deleted INTEGER NOT NULL DEFAULT 0)');
  }

  Future<int> insert(MyTransaction transaction) async {
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

  Future<List<MyTransaction>> getAll({
    @required TransactionFilterType transactionFilterType,
    @required bool deleted,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    String transactionTypeFilter;
    switch (transactionFilterType) {
      case TransactionFilterType.ALL:
        {
          break;
        }
      case TransactionFilterType.DAILY:
        {
          transactionTypeFilter = '%Y-%m-%d %H:%M:%S.%s';
          break;
        }
      case TransactionFilterType.MONTHLY:
        {
          transactionTypeFilter = '%Y-%m';
          break;
        }
      case TransactionFilterType.YEARLY:
        {
          transactionTypeFilter = '%Y';
          break;
        }
    }

    int deletedFilter = deleted ? 1 : 0;

    String rawQuery = 'SELECT';

    if (transactionFilterType == TransactionFilterType.DAILY) {
      rawQuery += ' $id,'
          ' $description,';
    }

    rawQuery += ' $date,'
        ' SUM($amount) $amount,'
        ' ${CategoryTable().id},'
        ' ${CategoryTable().color},'
        ' ${CategoryTable().name},'
        ' ${CategoryTable().type}'
        ' FROM $tableName'
        ' LEFT JOIN ${CategoryTable().tableName}'
        ' ON $category=${CategoryTable().id}'
        ' WHERE ${this.deleted}=$deletedFilter'
        ' GROUP BY $category';

    if (transactionTypeFilter != null) {
      rawQuery += ', STRFTIME(\'$transactionTypeFilter\', $date)'
          ' ORDER BY STRFTIME(\'$transactionTypeFilter\', $date) DESC';
    }

    final List<Map<String, dynamic>> maps = await db.rawQuery(rawQuery);

    // Convert the List<Map<String, dynamic> into a List<MyTransaction>.
    return List.generate(maps.length, (i) {
      return MyTransaction.fromMap(maps[i]);
    });
  }

  Future<double> getTotalBalance() async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;
    final String aliasColumn = 'total_balance';

    final rawQuery = 'SELECT SUM(CASE ${CategoryTable().type}'
        ' WHEN ${TransactionType.EXPENSE.value}'
        ' THEN -$amount'
        ' ELSE $amount END)'
        ' AS $aliasColumn'
        ' FROM $tableName'
        ' LEFT JOIN ${CategoryTable().tableName}'
        ' ON $category=${CategoryTable().id}'
        ' WHERE ${this.deleted}=0';

    final List<Map<String, dynamic>> maps = await db.rawQuery(rawQuery);

    return maps[0][aliasColumn];
  }

  Future<int> updateColumn({
    @required int id,
    @required String column,
    @required dynamic value,
  }) async {
    // Get a reference to the database.
    final Database db = await DatabaseHelper().db;

    // Row to update
    Map<String, dynamic> values = {
      column: value,
    };

    // Update the correct transaction.
    return db.update(
      tableName,
      values,
      // Ensure that the transaction has a matching id.
      where: '${this.id}=?',
      // Pass the transaction's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
