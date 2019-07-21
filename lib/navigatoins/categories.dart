import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/category.dart';

import '../transaction_type.dart';

class Categories extends StatelessWidget {
  Widget _buildCategoryWidgets(List<Category> categories) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {},
          title: Text(
            categories[index].name,
            style: TextStyle(color: categories[index].color),
          ),
          trailing: Text(categories[index].transactionType.name),
        );
      },
      itemCount: categories.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories = [
      Category(
        color: Colors.yellow,
        name: 'YBS',
        transactionType: TransactionType.EXPENSE,
      ),
      Category(
        color: Colors.green,
        name: 'Market',
        transactionType: TransactionType.EXPENSE,
      ),
      Category(
        color: Colors.blue,
        name: 'Internet',
        transactionType: TransactionType.EXPENSE,
      ),
      Category(
        color: Colors.orange,
        name: 'Phone Bill',
        transactionType: TransactionType.EXPENSE,
      ),
      Category(
        color: Colors.pink,
        name: 'Shopping',
        transactionType: TransactionType.EXPENSE,
      ),
    ];

    return _buildCategoryWidgets(categories);
  }
}
