import 'package:flutter/material.dart';

import '../transaction_type.dart';

class CategoryRoute extends StatefulWidget {
  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  int _radioGroupValue = TransactionType.EXPENSE.value;

  void _onRadioChanged(int value) {
    setState(() {
      _radioGroupValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('Category'),
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio(
                      value: TransactionType.EXPENSE.value,
                      groupValue: _radioGroupValue,
                      onChanged: _onRadioChanged,
                    ),
                    Text(TransactionType.EXPENSE.name),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: TransactionType.INCOME.value,
                      groupValue: _radioGroupValue,
                      onChanged: _onRadioChanged,
                    ),
                    Text(TransactionType.INCOME.name),
                  ],
                ),
              ],
            )
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
