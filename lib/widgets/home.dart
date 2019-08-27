import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/total.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/tiles/summary_tile.dart';
import 'package:flutter_money_manager/transaction_type.dart';
import 'package:flutter_money_manager/utils/number_format_util.dart';

class Home extends StatelessWidget {
  double getTotalBalance(List<Total> totals) {
    double totalBalance = 0;
    for (Total total in totals) {
      if (total.type == TransactionType.INCOME) {
        totalBalance += total.amount;
      } else {
        totalBalance -= total.amount;
      }
    }
    return totalBalance;
  }

  List<Widget> _buildChildren(BuildContext context, List<Total> totals) {
    return <Widget>[
      Expanded(
        child: Center(
          child: _buildTotalBalance(
            context,
            getTotalBalance(totals),
          ),
        ),
      ),
      Expanded(
        child: _buildSubTotals(
          context,
          totals,
        ),
      ),
    ];
  }

  Widget _buildPortrait(BuildContext context, List<Total> totals) {
    return Column(children: _buildChildren(context, totals));
  }

  Widget _buildLandscape(BuildContext context,
      double appBarHeight,
      List<Total> totals,) {
    return Padding(
      padding: EdgeInsets.only(bottom: appBarHeight),
      child: Row(children: _buildChildren(context, totals)),
    );
  }

  Widget _buildTotalBalance(BuildContext context, double amount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          standardNumberFormat(amount),
          style: Theme
              .of(context)
              .textTheme
              .display2
              .copyWith(
            color: Colors.white,
          ),
        ),
        Text(
          'Total Balance',
          style: Theme
              .of(context)
              .textTheme
              .caption,
        ),
      ],
    );
  }

  Widget _buildSubTotals(BuildContext context, List<Total> totals) {
    Total incomeTotal, expenseTotal;
    for (Total total in totals) {
      if (total.type == TransactionType.INCOME) {
        incomeTotal = total;
      } else {
        expenseTotal = total;
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Divider(),
        SummaryTile(
          onTap: () {
            // TODO : go to report with "INCOME" filter
          },
          iconData: Icons.trending_up,
          amount: incomeTotal != null ? incomeTotal.amount : 0,
          label: 'Total Income',
        ),
        Divider(),
        SummaryTile(
          onTap: () {
            // TODO : go to report with "EXPENSE" filter
          },
          iconData: Icons.trending_down,
          amount: expenseTotal != null ? expenseTotal.amount : 0,
          label: 'Total Expense',
        ),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: TransactionTable().getTotals(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            return OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.portrait) {
                  return _buildPortrait(
                    context,
                    snapshot.data,
                  );
                } else {
                  return _buildLandscape(
                    context,
                    AppBar().preferredSize.height,
                    snapshot.data,
                  );
                }
              },
            );
          } else {
            return Center(child: new CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
