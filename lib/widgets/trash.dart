import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/models/list_item.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/repository/repository.dart';
import 'package:flutter_money_manager/widgets/future_list_item_builder.dart';
import 'package:flutter_money_manager/widgets/heading_item_tile.dart';
import 'package:flutter_money_manager/widgets/transaction_item_tile.dart';

class Trash extends StatefulWidget {
  @override
  _TrashState createState() => _TrashState();
}

class _TrashState extends State<Trash> {
  void _showOptionsModalBottomSheet(
    BuildContext context,
    MyTransaction transaction,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.restore),
                  title: new Text('Restore'),
                  onTap: () async {
                    Navigator.pop(context);
                    await Repository().restoreTransaction(transaction.id);
                    setState(() {});
                  }),
            ],
          );
        });
  }

  Widget _listItemBuilder(List<ListItem> items) {
    return Scrollbar(
      child: ListView.builder(
        itemBuilder: (context, index) {
          if (items[index] is HeadingItem) {
            return HeadingItemTile(
              index: index,
              item: items[index] as HeadingItem,
            );
          } else {
            TransactionItem item = items[index] as TransactionItem;
            return TransactionItemTile(
              item: item,
              onLongPress: () => _showOptionsModalBottomSheet(
                context,
                item.transaction,
              ),
            );
          }
        },
        itemCount: items.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureListItemBuilder(
      deleted: true,
      transactionFilterType: TransactionFilterType.DAILY,
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
        return Center(
          child: Text('Empty'),
        );
      },
      errorBuilderFn: (BuildContext context4, String error) {
        return Center(
          child: Text(error),
        );
      },
    );
  }
}
