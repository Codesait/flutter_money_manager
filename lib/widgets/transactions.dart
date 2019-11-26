import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/routes/transaction_route.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/utils/date_format_util.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';

import 'color_circle.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  Future<void> deleteTransaction(
      BuildContext context, MyTransaction transaction) async {
    int result = await TransactionTable().delete(transaction.id);
    if (result <= 0) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Fail to delete.')));

      return false;
    }

    setState(() {});

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Deleted successfully.')));
  }

  void _showOptionsModalBottomSheet(
      BuildContext context, MyTransaction transaction) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.edit),
                  title: new Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TransactionRoute(transaction: transaction)));
                  }),
              new ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  deleteTransaction(context, transaction);
                },
              ),
            ],
          );
        });
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
          String description = (item.transaction.description == null ||
                  item.transaction.description.trim().isEmpty)
              ? 'No Description'
              : item.transaction.description;
          double amount = item.transaction.amount;
          if (item.transaction.category.transactionType ==
              TransactionType.EXPENSE) {
            amount *= -1;
          }
          return ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TransactionRoute(transaction: item.transaction)));
            },
            onLongPress: () =>
                _showOptionsModalBottomSheet(context, item.transaction),
            leading: ColorCircle(color: item.transaction.category.color),
            title: Text(
              item.transaction.category.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              description,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            trailing: Text(
              standardNumberFormat(amount),
              style: Theme.of(context).textTheme.caption,
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
