import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/utils/date_format_util.dart';

import 'category.dart';

class MyTransaction {
  int id;
  DateTime date;
  double amount;
  String description;
  Category category;

  MyTransaction({
    this.id,
    this.date,
    this.amount,
    this.description,
    this.category,
  });

  MyTransaction.fromMap(Map<String, dynamic> map) {
    id = map[TransactionTable().id];
    date = map[TransactionTable().date];
    amount = map[TransactionTable().amount];
    description = map[TransactionTable().description];
    category = map[TransactionTable().category];
  }

  Map<String, dynamic> toMap() {
    return {
      TransactionTable().id: id,
      TransactionTable().date: date.millisecond,
      TransactionTable().amount: amount,
      TransactionTable().description: description,
      TransactionTable().category: category.id,
    };
  }

  @override
  String toString() {
    return 'Transaction{\n'
        'id : $id\n'
        'date : ${standardLongDateFormat(date)}\n'
        'amount : $amount\n'
        'description : $description\n'
        'category : $category\n'
        '}';
  }
}
