import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'category_table.dart';
import 'transaction_table.dart';

class DatabaseHelper {
  final String _databaseName = 'money_manager.db';
  final int _databaseVersion = 1;

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  Future<Database> _initDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), _databaseName),
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    CategoryTable().onCreate(db, version);
    TransactionTable().onCreate(db, version);

    // create other tables ...
  }
}
