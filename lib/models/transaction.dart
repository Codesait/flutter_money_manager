import 'category.dart';

class Transaction {
  int id;
  DateTime date;
  double amount;
  String description;
  Category category;

  Transaction({
    this.id,
    this.date,
    this.amount,
    this.description,
    this.category,
  });
}
