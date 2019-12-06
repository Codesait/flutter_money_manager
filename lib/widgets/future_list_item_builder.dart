import 'package:flutter/material.dart';
import 'package:flutter_money_manager/enums/transaction_filter_type.dart';
import 'package:flutter_money_manager/enums/transaction_type.dart';
import 'package:flutter_money_manager/models/list_item.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/utils/date_format_util.dart';

typedef LoadingBuilderFn = Widget Function(BuildContext context);
typedef ListItemBuilderFn = Widget Function(
  BuildContext context,
  List<ListItem> listItems,
);
typedef EmptyListItemBuilderFn = Widget Function(BuildContext context);
typedef ErrorBuilderFn = Widget Function(BuildContext context, String error);

class FutureListItemBuilder extends StatefulWidget {
  final TransactionFilterType transactionFilterType;
  final bool deleted;
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
      @required this.errorBuilderFn,
      this.deleted = false})
      : assert(transactionFilterType != null),
        assert(deleted != null),
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

  String getDateFormattedString(
    TransactionFilterType transactionFilterType,
    DateTime date,
  ) {
    switch (transactionFilterType) {
      case TransactionFilterType.ALL:
        return '';
      case TransactionFilterType.DAILY:
        return shortDateFormat(getDateWithoutTime(date));
      case TransactionFilterType.MONTHLY:
        return shortDateFormatWithoutDay(getDateWithoutDayAndTime(date));
      case TransactionFilterType.YEARLY:
        return shortDateFormatWithoutMonthAndDay(
            getDateWithoutMonthAndDayAndTime(date));
      default:
        throw UnsupportedError('$transactionFilterType is not supported!');
    }
  }

  List<ListItem> _convertMyTransactionsToListItems(
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

        if (transactionFilterType != TransactionFilterType.ALL) {
          if (t.category.transactionType == TransactionType.INCOME) {
            balance += t.amount;
          } else {
            balance -= t.amount;
          }
        }
      }
    }

    if (transactionFilterType != TransactionFilterType.ALL) {
      list.add(HeadingItem(
        heading: key,
        balance: balance,
      ));
    }

    list.addAll(tempList);

    // Remove transactions those are already added in tempList
    transactions.removeWhere(
        (t) => key == getDateFormattedString(transactionFilterType, t.date));

    return _convertMyTransactionsToListItems(
      transactions,
      list,
      transactionFilterType,
    );
  }

  void _getAndSetTransactions() {
    TransactionTable()
        .getAll(
      transactionFilterType: widget.transactionFilterType,
      deleted: widget.deleted,
    )
        .then((List<MyTransaction> myTransactions) {
      setState(() {
        _loading = false;
        _listItems = _convertMyTransactionsToListItems(
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
