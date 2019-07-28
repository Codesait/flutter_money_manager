import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/transaction.dart';
import 'package:flutter_money_manager/utils/date_format_util.dart';
import 'package:flutter_money_manager/widgets/category_list.dart';

class TransactionRoute extends StatefulWidget {
  @override
  _TransactionRouteState createState() => _TransactionRouteState();
}

class _TransactionRouteState extends State<TransactionRoute> {
  Transaction _transaction = Transaction(date: DateTime.now());

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTime = await showDatePicker(
      context: context,
      initialDate: _transaction.date,
      firstDate: DateTime(1996),
      lastDate: DateTime(3000),
    );

    if (dateTime != null && dateTime != _transaction.date) {
      DateTime now = DateTime.now();
      setState(() {
        _transaction.date = DateTime(
          dateTime.year,
          dateTime.month,
          dateTime.day,
          now.hour,
          now.minute,
          now.second,
        );
      });
    }
  }

  void _showCategoryChooserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 16.0,
              ),
              child: Categories(
                shrinkWrap: true,
                onTap: (category) {
                  setState(() {
                    _transaction.category = category;
                  });
                  print(_transaction.category.name);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Transaction'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {},
        ),
      ],
    );

    final body = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () => _showDatePicker(context),
              leading: Icon(Icons.date_range),
              title: Text(standardLongDateFormat(_transaction.date)),
            ),
            Divider(),
            ListTile(
              onTap: () => _showCategoryChooserDialog(context),
              leading: Icon(Icons.category),
              title: Text(_transaction.category == null
                  ? 'Choose Category'
                  : _transaction.category.name),
              trailing: Icon(Icons.arrow_drop_down),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Amount',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.description),
              title: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Description',
                ),
              ),
            ),
            Divider(),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }
}
