import 'package:flutter/material.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/tiles/summary_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appBarHeight = AppBar().preferredSize.height;

    Widget _allTotalWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '1,100,000',
          style: Theme
              .of(context)
              .textTheme
              .display2
              .copyWith(
            color: Colors.white,
          ),
        ),
        Text(
          'Total Amount',
          style: Theme
              .of(context)
              .textTheme
              .caption,
        ),
      ],
    );

    Widget _subTotalWidget = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Divider(),
        SummaryTile(
          onTap: () {
            // TODO : go to report with "INCOME" filter
          },
          iconData: Icons.trending_up,
          amount: 2000000,
          label: 'Total Income',
        ),
        Divider(),
        SummaryTile(
          onTap: () {
            // TODO : go to report with "EXPENSE" filter
          },
          iconData: Icons.trending_down,
          amount: 900000,
          label: 'Total Expense',
        ),
        Divider(),
      ],
    );

    Widget _portrait = Column(
      children: <Widget>[
        Expanded(child: Center(child: _allTotalWidget)),
        Expanded(child: _subTotalWidget),
      ],
    );

    Widget _landscape = Padding(
      padding: EdgeInsets.only(bottom: appBarHeight),
      child: Row(
        children: <Widget>[
          Expanded(child: Center(child: _allTotalWidget)),
          Expanded(child: _subTotalWidget),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: TransactionTable().getTotals(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            print('snapshot.data : ${snapshot.data}');
            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return _portrait;
                } else {
                  return _landscape;
                }
              },
            );
          } else {
            return new CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
