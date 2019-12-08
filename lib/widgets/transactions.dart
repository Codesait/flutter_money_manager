import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/models/list_item.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/repository/repository.dart';
import 'package:flutter_money_manager/routes/transaction_route.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';
import 'package:flutter_money_manager/widgets/custom_tabbar.dart';
import 'package:flutter_money_manager/widgets/future_list_item_builder.dart';
import 'package:flutter_money_manager/widgets/transaction_item_tile.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  TransactionFilterType transactionFilterType = TransactionFilterType.DAILY;

  Future<void> deleteTransaction(
    BuildContext context,
    MyTransaction transaction,
  ) async {
    int result = await Repository().moveToTrash(transaction.id);
    if (result <= 0) {
      Scaffold.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('Fail to delete.')));

      return false;
    }

    setState(() {});

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Deleted successfully.')));
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

  void _onTap(BuildContext context, MyTransaction transaction) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionRoute(
          transaction: transaction,
        ),
      ),
    );
  }

  Widget _transactionItemBuilder({
    BuildContext context,
    TransactionItem item,
    bool isDaily,
  }) {
    return TransactionItemTile(
      onTap: () => isDaily ? _onTap(context, item.transaction) : null,
      onLongPress: () => isDaily
          ? _showOptionsModalBottomSheet(context, item.transaction)
          : null,
      item: item,
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
              context: context,
              item: items[index] as TransactionItem,
              isDaily: transactionFilterType == TransactionFilterType.DAILY,
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
