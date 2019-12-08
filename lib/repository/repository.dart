import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';

class Repository {
  final TransactionTable _transactionTable = TransactionTable();

  Future<double> getTotalBalance() => _transactionTable.getTotalBalance();

  Future<int> moveToTrash(int id) =>
      _transactionTable.updateColumn(
        id: id,
        column: _transactionTable.deleted,
        value: 1,
      );

  Future<int> restoreTransaction(int id) => _transactionTable.updateColumn(
        id: id,
        column: _transactionTable.deleted,
        value: 0,
      );
}
