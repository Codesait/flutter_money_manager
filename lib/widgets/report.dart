import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/utils/date_format_util.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';

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
              standardNumberFormat(item.transaction.amount) +
                  ' - ${item.transaction.category.transactionType.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              '${item.transaction.category.name} $description',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            trailing: Text(standardTimeFormat(item.transaction.date)),
          );
        }
      },
      itemCount: items.length,
    );
  }

  List<ListItem> _convertListOfMyTransactionToListItem(
      List<MyTransaction> transactions,
      List<ListItem> list,) {
    if (transactions.length == 0) {
      return list;
    }

    String key = shortDateFormat(getDateWithoutTime(transactions[0].date));

    list.add(HeadingItem(heading: key));

    for (MyTransaction t in transactions) {
      if (key == shortDateFormat(getDateWithoutTime(t.date))) {
        list.add(TransactionItem(transaction: t));
      }
    }

    transactions.removeWhere(
            (t) => key == shortDateFormat(getDateWithoutTime(t.date)));

    return _convertListOfMyTransactionToListItem(transactions, list);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TransactionTable().getAll(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else if (snapshot.hasData) {
          return _buildTransactionWidgets(
            _convertListOfMyTransactionToListItem(
              snapshot.data,
              List<ListItem>(),
            ),
          );
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
