import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/category.dart';
import 'package:flutter_money_manager/models/transaction.dart';

import '../transaction_type.dart';

class Report extends StatelessWidget {
  Widget _buildTransactionWidgets(List<ListItem> items) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (items[index] is HeadingItem) {
          HeadingItem item = items[index];
          return ListTile(
            title: Text(item.heading),
          );
        } else {
          TransactionItem item = items[index];
          return ListTile(
            onTap: () {},
            leading: Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: item.transaction.category.color,
                radius: 10.0,
              ),
            ),
            title: Text(
              '${item.transaction.amount}' +
                  ' - ${item.transaction.category.transactionType.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              '${item.transaction.category.name}' +
                  ' - ${item.transaction.description}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            trailing: Text('${item.transaction.date.year}'),
          );
        }
      },
      itemCount: items.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ListItem> items = [
      HeadingItem(heading: 'Sun 21, Jul 2019'),
      TransactionItem(
        transaction: Transaction(
          date: DateTime.now(),
          amount: 1000,
          description: 'Go and back',
          category: Category(
            color: Colors.yellow,
            name: 'YBS',
            transactionType: TransactionType.EXPENSE,
          ),
        ),
      ),
      TransactionItem(
        transaction: Transaction(
          date: DateTime.now(),
          amount: 500,
          description: 'Street foods',
          category: Category(
            color: Colors.orange,
            name: 'Food',
            transactionType: TransactionType.EXPENSE,
          ),
        ),
      ),
      TransactionItem(
        transaction: Transaction(
          date: DateTime.now(),
          amount: 4000,
          description: 'Meat and vegetables',
          category: Category(
            color: Colors.green,
            name: 'Market',
            transactionType: TransactionType.EXPENSE,
          ),
        ),
      ),
      HeadingItem(heading: 'Sat 20, Jul 2019'),
      TransactionItem(
        transaction: Transaction(
          date: DateTime.now(),
          amount: 5000,
          description: 'Meat and vegetables',
          category: Category(
            color: Colors.green,
            name: 'Market',
            transactionType: TransactionType.EXPENSE,
          ),
        ),
      ),
      TransactionItem(
        transaction: Transaction(
          date: DateTime.now(),
          amount: 1000,
          description: 'Top up MyTel',
          category: Category(
            color: Colors.orange,
            name: 'Phone Bill',
            transactionType: TransactionType.EXPENSE,
          ),
        ),
      ),
      HeadingItem(heading: 'Fri 19, Jul 2019'),
      TransactionItem(
        transaction: Transaction(
          date: DateTime.now(),
          amount: 5000,
          description: 'Meat and vegetables',
          category: Category(
            color: Colors.green,
            name: 'Market',
            transactionType: TransactionType.EXPENSE,
          ),
        ),
      ),
      TransactionItem(
        transaction: Transaction(
          date: DateTime.now(),
          amount: 2500,
          description: 'Meet and eat with brother at Thuka'
              ' with so so long reason and history about him.',
          category: Category(
            color: Colors.red,
            name: 'Meeting',
            transactionType: TransactionType.EXPENSE,
          ),
        ),
      ),
      TransactionItem(
        transaction: Transaction(
          date: DateTime.now(),
          amount: 1600,
          description: 'Go and back from Thuka.',
          category: Category(
            color: Colors.yellow,
            name: 'YBS',
            transactionType: TransactionType.EXPENSE,
          ),
        ),
      ),
      TransactionItem(
        transaction: Transaction(
          date: DateTime.now(),
          amount: 20000,
          description: 'Shopping and eat.',
          category: Category(
            color: Colors.pink,
            name: 'Shopping',
            transactionType: TransactionType.EXPENSE,
          ),
        ),
      ),
    ];

    return _buildTransactionWidgets(items);
  }
}

// The base class for the different types of items the list can contain.
abstract class ListItem {}

// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem({
    @required this.heading,
  }) : assert(heading != null);
}

// A ListItem that contains data to display a message.
class TransactionItem implements ListItem {
  final Transaction transaction;

  TransactionItem({
    @required this.transaction,
  }) : assert(transaction != null);
}
