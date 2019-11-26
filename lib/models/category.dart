import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:flutter_money_manager/utils/color_util.dart';

class Category {
  int id;
  Color color;
  String name;
  TransactionType transactionType;

  Category({this.id, this.color, this.name, this.transactionType});

  Category.fromMap(Map<String, dynamic> map) {
    id = map[CategoryTable().id];
    color = valueToColor(map[CategoryTable().color]);
    name = map[CategoryTable().name];
    transactionType = TransactionType.valueOf(map[CategoryTable().type]);
  }

  Map<String, dynamic> toMap() {
    return {
      CategoryTable().id: id,
      CategoryTable().color: color.value,
      CategoryTable().name: name,
      CategoryTable().type: transactionType.value,
    };
  }

  void checkValidationAndThrow() {
    if (color == null) {
      throw Exception("No color!");
    }

    if (name == null || name.isEmpty) {
      throw Exception("No name!");
    }

    if (transactionType == null) {
      throw Exception("No transaction type!");
    }
  }

  @override
  String toString() {
    return 'Category{\n'
        'id : $id\n'
        'color : ${color.value}\n'
        'name : $name\n'
        'transactionType : ${transactionType.name}\n'
        '}';
  }
}
