import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';

class Repository {
  final TransactionTable _transactionTable = TransactionTable();

  Future<double> getTotalBalance() => _transactionTable.getTotalBalance();

  Future<int> markTransactionAsDeleted(int id) =>
      _transactionTable.markTransactionAsDeleted(id);
}
