import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:meta/meta.dart';

class Total {
  TransactionType type;
  double amount;

  Total({
    @required this.type,
    @required this.amount,
  })  : assert(type != null),
        assert(amount != null);

  Total.fromMap(Map<String, dynamic> map) {
    type = TransactionType.valueOf(map[CategoryTable().type]);
    amount = map[TransactionTable().amount];
  }

  @override
  String toString() {
    return 'Total{\n'
        'type : $type\n'
        'amount : $amount\n'
        '}';
  }
}
