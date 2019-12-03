import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/list_item.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/routes/transaction_route.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';
import 'package:flutter_money_manager/widgets/custom_tabbar.dart';
import 'package:flutter_money_manager/widgets/future_list_item_builder.dart';

import 'color_circle.dart';

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

  Widget _headingItemBuilder(int index, HeadingItem item) {
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
  }

  Widget _transactionItemBuilder(
    int index,
    TransactionItem item,
    bool isDaily,
  ) {
    String description = (item.transaction.description == null ||
            item.transaction.description.trim().isEmpty)
        ? 'No Description'
        : item.transaction.description;
    double amount = item.transaction.amount;
    if (item.transaction.category.transactionType == TransactionType.EXPENSE) {
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

  Widget _listItemBuilder(List<ListItem> items) {
    return Scrollbar(
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (items[index] is HeadingItem) {
            return _headingItemBuilder(index, items[index] as HeadingItem);
          } else {
            return _transactionItemBuilder(
              index,
              items[index] as TransactionItem,
              transactionFilterType == TransactionFilterType.DAILY,
            );
          }
        },
        itemCount: items.length,
      ),
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
              return _listItemBuilder(listItems);
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
