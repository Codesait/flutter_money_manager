import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../transaction_type.dart';

class Category {
  final int id;
  final ColorSwatch color;
  final String name;
  final TransactionType transactionType;

  Category({
    this.id = 0,
    @required this.color,
    @required this.name,
    @required this.transactionType,
  })  : assert(id >= 0),
        assert(color != null),
        assert(name != null),
        assert(transactionType != null);
}
