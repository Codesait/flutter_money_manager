import 'package:flutter/material.dart';
import 'package:flutter_money_manager/tiles/summary_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery
        .of(context)
        .size
        .longestSide / 4;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              left: 32.0,
              right: 32.0,
            ),
            alignment: Alignment.center,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
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
                // to show summary above of FAB button
                SizedBox(height: 60.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
