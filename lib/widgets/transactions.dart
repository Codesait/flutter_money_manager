import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/routes/transaction_route.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/utils/date_format_util.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';
import 'package:flutter_money_manager/widgets/custom_tabbar.dart';

import 'color_circle.dart';

List<ListItem> _convertListOfMyTransactionToListItem(
  List<MyTransaction> transactions,
  List<ListItem> list,
  TransactionFilterType transactionFilterType,
) {
  if (transactions.length == 0) {
    return list;
  }

  List<ListItem> tempList = [];

  String key = getDateFormattedString(
    transactionFilterType,
    transactions[0].date,
  );

  double balance = 0;
  for (MyTransaction t in transactions) {
    if (key == getDateFormattedString(transactionFilterType, t.date)) {
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
  transactions.removeWhere(
      (t) => key == getDateFormattedString(transactionFilterType, t.date));

  return _convertListOfMyTransactionToListItem(
    transactions,
    list,
    transactionFilterType,
  );
}

String getDateFormattedString(
  TransactionFilterType transactionFilterType,
  DateTime date,
) {
  switch (transactionFilterType) {
    case TransactionFilterType.DAILY:
      {
        return shortDateFormat(getDateWithoutTime(date));
      }
    case TransactionFilterType.MONTHLY:
      {
        return shortDateFormatWithoutDay(getDateWithoutDayAndTime(date));
      }
    case TransactionFilterType.YEARLY:
      {
        return shortDateFormatWithoutMonthAndDay(
            getDateWithoutMonthAndDayAndTime(date));
      }
    default:
      {
        throw UnsupportedError('$transactionFilterType is not supported!');
      }
  }
}

typedef LoadingBuilderFn = Widget Function(BuildContext context);
typedef ListItemBuilderFn = Widget Function(
  BuildContext context,
  List<ListItem> listItems,
);
typedef EmptyListItemBuilderFn = Widget Function(BuildContext context);
typedef ErrorBuilderFn = Widget Function(BuildContext context, String error);

class FutureListItemBuilder extends StatefulWidget {
  final TransactionFilterType transactionFilterType;
  final LoadingBuilderFn loadingBuilderFn;
  final ListItemBuilderFn listItemBuilderFn;
  final EmptyListItemBuilderFn emptyListItemBuilderFn;
  final ErrorBuilderFn errorBuilderFn;

  const FutureListItemBuilder(
      {Key key,
      @required this.transactionFilterType,
      @required this.loadingBuilderFn,
      @required this.listItemBuilderFn,
      @required this.emptyListItemBuilderFn,
      @required this.errorBuilderFn})
      : assert(transactionFilterType != null),
        assert(loadingBuilderFn != null),
        assert(listItemBuilderFn != null),
        assert(emptyListItemBuilderFn != null),
        assert(errorBuilderFn != null),
        super(key: key);

  @override
  _FutureListItemBuilderState createState() => _FutureListItemBuilderState();
}

class _FutureListItemBuilderState extends State<FutureListItemBuilder> {
  bool _loading = true;
  String _error;
  List<ListItem> _listItems;

  void _getAndSetTransactions() {
    TransactionTable()
        .getAllByFilter(widget.transactionFilterType)
        .then((List<MyTransaction> myTransactions) {
      setState(() {
        _loading = false;
        _listItems = _convertListOfMyTransactionToListItem(
          myTransactions,
          List<ListItem>(),
          widget.transactionFilterType,
        );
      });
    }).catchError((error) {
      setState(() {
        _loading = false;
        _listItems = null;
        this._error = error;
      });
    });
  }

  @override
  void initState() {
    _getAndSetTransactions();
    super.initState();
  }

  @override
  void didUpdateWidget(FutureListItemBuilder oldWidget) {
    _getAndSetTransactions();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return widget.loadingBuilderFn(context);
    } else if (_listItems != null && _listItems.isEmpty) {
      return widget.emptyListItemBuilderFn(context);
    } else if (_listItems != null && _listItems.isNotEmpty) {
      return widget.listItemBuilderFn(context, _listItems);
    } else {
      return widget.errorBuilderFn(context, _error);
    }
  }
}

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TransactionFilterType transactionFilterType = TransactionFilterType.DAILY;

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
    final isDaily = transactionFilterType == TransactionFilterType.DAILY;
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
            onTap: () => isDaily
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransactionRoute(
                        transaction: item.transaction,
                      ),
                    ),
                  )
                : null,
            onLongPress: () => isDaily
                ? _showOptionsModalBottomSheet(context, item.transaction)
                : null,
            leading: ColorCircle(color: item.transaction.category.color),
            title: Text(
              item.transaction.category.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: isDaily
                ? Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  )
                : null,
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

  void _onTransactionFilterTypeChanged(
      TransactionFilterType transactionFilterType) {
    setState(() {
      this.transactionFilterType = transactionFilterType;
    });
  }

  Widget getTabbar(TransactionFilterType transactionFilterType) {
    return CustomTabbar(
      customTabbarItems: [
        CustomTabbarItem(
          onTap: () =>
              _onTransactionFilterTypeChanged(TransactionFilterType.DAILY),
          child: Text(
            'Daily',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        CustomTabbarItem(
          onTap: () =>
              _onTransactionFilterTypeChanged(TransactionFilterType.MONTHLY),
          child: Text(
            'Monthly',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        CustomTabbarItem(
          onTap: () =>
              _onTransactionFilterTypeChanged(TransactionFilterType.YEARLY),
          child: Text(
            'Yearly',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
      selectedIndex: transactionFilterType.index,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        getTabbar(transactionFilterType),
        Expanded(
          child: FutureListItemBuilder(
            transactionFilterType: transactionFilterType,
            loadingBuilderFn: (BuildContext context1) {
              return CircularProgressIndicator();
            },
            listItemBuilderFn: (
              BuildContext context2,
              List<ListItem> listItems,
            ) {
              return _buildTransactionWidgets(listItems);
            },
            emptyListItemBuilderFn: (BuildContext context3) {
              return buildListInitialGuideWidget('transaction');
            },
            errorBuilderFn: (BuildContext context4, String error) {
              return Center(
                child: Text(error),
              );
            },
          ),
        )
      ],
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
