import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/routes/transaction_route.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/transaction_type.dart';
import 'package:flutter_money_manager/utils/date_format_util.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';

import 'color_circle.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  Future<bool> deleteTransaction(
      BuildContext context, MyTransaction transaction) async {
    try {
      int result = await TransactionTable().delete(transaction.id);

      return result > 0;
    } catch (exception) {
      print(
          '_buildTransactionWidgets() : Fail to delete transaction! $exception');

      return false;
    }
  }

  Widget _buildTransactionWidgets(List<ListItem> items) {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (items[index] is HeadingItem) {
          HeadingItem item = items[index];
          return Column(
            children: <Widget>[
              index == 0 ? SizedBox(height: 4.0) : Divider(),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  top: 8.0,
                  right: 16.0,
                  bottom: 8.0,
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(child: Text(item.heading)),
                    Text(
                      standardNumberFormat(item.balance),
                      style: TextStyle(
                        color: item.balance < 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        } else {
          TransactionItem item = items[index];
          String description = item.transaction.description == null
              ? ''
              : '- ${item.transaction.description}';
          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(item.transaction.id.toString()),
            onDismissed: (direction) async {
              bool result = await deleteTransaction(context, item.transaction);
              if (!result) {
                // Need to refresh UI, cause dismissible always remove item
                // form UI when call 'onDismissed'
                setState(() {});

                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("Fail to delete.")));
                return;
              }

              setState(() {
                items.removeAt(index);
              });

              // TODO : add 'Undo' function
              Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Deleted a transaction successfully.")));
            },
            // Show a red background as the item is swiped away.
            background: Container(
              color: Colors.red,
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Icon(Icons.delete),
                  Icon(Icons.delete),
                ],
              ),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TransactionRoute(transaction: item.transaction)));
              },
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
              trailing: Text(
                standardTimeFormat(item.transaction.date),
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          );
        }
      },
      itemCount: items.length,
    );
  }

  List<ListItem> _convertListOfMyTransactionToListItem(
    List<MyTransaction> transactions,
    List<ListItem> list,
  ) {
    if (transactions.length == 0) {
      return list;
    }

    List<ListItem> tempList = [];

    String key = shortDateFormat(getDateWithoutTime(transactions[0].date));

    double balance = 0;
    for (MyTransaction t in transactions) {
      if (key == shortDateFormat(getDateWithoutTime(t.date))) {
        tempList.add(TransactionItem(transaction: t));

        if (t.category.transactionType == TransactionType.INCOME) {
          balance += t.amount;
        } else {
          balance -= t.amount;
        }
      }
    }

    list.add(HeadingItem(
      heading: key,
      balance: balance,
    ));

    list.addAll(tempList);

    // Remove transactions those are already added in tempList
    transactions
        .removeWhere((t) => key == shortDateFormat(getDateWithoutTime(t.date)));

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
          if (snapshot.data.length > 0) {
            return _buildTransactionWidgets(
              _convertListOfMyTransactionToListItem(
                snapshot.data,
                List<ListItem>(),
              ),
            );
          } else {
            return buildListInitialGuideWidget('transaction');
          }
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
  final double balance;

  HeadingItem({
    @required this.heading,
    @required this.balance,
  })  : assert(heading != null),
        assert(balance != null);
}

// A ListItem that contains data to display a message.
class TransactionItem implements ListItem {
  final MyTransaction transaction;

  TransactionItem({
    @required this.transaction,
  }) : assert(transaction != null);
}
