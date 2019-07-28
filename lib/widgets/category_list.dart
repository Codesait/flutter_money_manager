import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/category.dart';

import '../transaction_type.dart';
import 'color_circle.dart';

class Categories extends StatelessWidget {
  final ValueChanged<Category> onTap;
  final bool shrinkWrap;

  Categories({
    Key key,
    @required this.onTap,
    this.shrinkWrap = false,
  })
      : assert(onTap != null),
        super(key: key);

  Widget _buildCategoryWidgets(List<Category> categories) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () => onTap(categories[index]),
          leading: ColorCircle(color: categories[index].color),
          title: Text(
            categories[index].name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
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
        name:
        'Phone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone BillPhone Bill',
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
