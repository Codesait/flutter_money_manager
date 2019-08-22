import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/category.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';

import '../transaction_type.dart';
import 'color_circle.dart';

class Report extends StatelessWidget {
  Widget _buildTransactionWidgets(List<ListItem> items) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (items[index] is HeadingItem) {
          HeadingItem item = items[index];
          return Column(
            children: <Widget>[
              index == 0 ? SizedBox(height: 4.0) : Divider(),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 8.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                child: Text(item.heading),
              ),
              Divider(),
            ],
          );
        } else {
          TransactionItem item = items[index];
          String description = item.transaction.description == null
              ? ''
              : '- ${item.transaction.description}';
          return ListTile(
            onTap: () {},
            leading: ColorCircle(color: item.transaction.category.color),
            title: Text(
              '${item.transaction.amount}' +
                  ' - ${item.transaction.category.transactionType.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              '${item.transaction.category.name} $description',
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

  List<ListItem> _convertTransactionListToListItem(
      List<MyTransaction> transactions) {
    List<ListItem> items = [];
    for (MyTransaction transaction in transactions) {
      items.add(TransactionItem(transaction: transaction));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    List<ListItem> items = [
      HeadingItem(heading: 'Sun 21, Jul 2019'),
      TransactionItem(
        transaction: MyTransaction(
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
        transaction: MyTransaction(
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
        transaction: MyTransaction(
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
        transaction: MyTransaction(
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
        transaction: MyTransaction(
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
        transaction: MyTransaction(
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
        transaction: MyTransaction(
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
        transaction: MyTransaction(
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
        transaction: MyTransaction(
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

    return FutureBuilder(
      future: TransactionTable().getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          return _buildTransactionWidgets(
              _convertTransactionListToListItem(snapshot.data));
        } else {
          return new CircularProgressIndicator();
        }
      },
    );
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
  final MyTransaction transaction;

  TransactionItem({
    @required this.transaction,
  }) : assert(transaction != null);
}
