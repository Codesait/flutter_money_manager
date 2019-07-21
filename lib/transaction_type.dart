class TransactionType {
  final int _value;
  final String _name;

  const TransactionType._internal(this._value, this._name);

  static const INCOME = const TransactionType._internal(1, 'Income');
  static const EXPENSE = const TransactionType._internal(2, 'Expense');

  get value => _value;

  get name => _name;
}
