import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/list_item.dart';
import 'package:flutter_money_manager/repository/repository.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';
import 'package:flutter_money_manager/widgets/color_circle.dart';
import 'package:flutter_money_manager/widgets/future_list_item_builder.dart';

class Home extends StatelessWidget {
  Widget _totalBalanceBuilder(BuildContext context, double totalBalance) {
    return Container(
      height: 150.0,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            standardNumberFormat(totalBalance),
            style: Theme.of(context).textTheme.display2.copyWith(
                  color: Colors.white,
                ),
          ),
          Text(
            'Total Balance',
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }

  Widget _listItemBuilder(List<ListItem> items) {
    return Scrollbar(
      child: ListView.builder(
        itemBuilder: (context, index) {
          TransactionItem item = items[index] as TransactionItem;
          double amount = item.transaction.amount;
          if (item.transaction.category.transactionType ==
              TransactionType.EXPENSE) {
            amount *= -1;
          }
          return ListTile(
            leading: ColorCircle(color: item.transaction.category.color),
            title: Text(
              item.transaction.category.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            trailing: Text(
              standardNumberFormat(amount),
              style: Theme.of(context).textTheme.caption,
            ),
            onTap: () => print(item.transaction.category.name),
          );
        },
        itemCount: items.length,
      ),
    );
  }

  Widget _futureTotalBalanceBuilder() {
    return FutureBuilder(
      future: Repository().getTotalBalance(),
      builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
        double totalBalance = snapshot.hasData ? snapshot.data : 0.0;
        return _totalBalanceBuilder(context, totalBalance);
      },
    );
  }

  Widget _portraitBuilder(BuildContext context, Widget header, Widget list) {
    return Column(children: [
      header,
      Expanded(child: list),
    ]);
  }

  Widget _landscapeBuilder(BuildContext context, Widget header, Widget list) {
    return Row(children: [
      Expanded(child: header),
      Expanded(child: list),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    Widget header = _futureTotalBalanceBuilder();

    Widget list = FutureListItemBuilder(
      transactionFilterType: TransactionFilterType.ALL,
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
        return Container();
      },
      errorBuilderFn: (BuildContext context4, String error) {
        return Center(
          child: Text(error),
        );
      },
    );

    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return _portraitBuilder(context, header, list);
      } else {
        return _landscapeBuilder(context, header, list);
      }
    });
  }
}
