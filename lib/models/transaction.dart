import 'package:meta/meta.dart';

import 'category.dart';

class Transaction {
  final int id;
  final DateTime date;
  final double amount;
  final String description;
  final Category category;

  Transaction({
    this.id = 0,
    @required this.date,
    @required this.amount,
    @required this.description,
    @required this.category,
  })  : assert(id >= 0),
        assert(date != null),
        assert(amount != null && amount >= 0),
        assert(category != null);
}
