import 'package:flutter/material.dart';

class TransactionRoute extends StatefulWidget {
  @override
  _TransactionRouteState createState() => _TransactionRouteState();
}

class _TransactionRouteState extends State<TransactionRoute> {
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
              onTap: () {},
              leading: Icon(Icons.date_range),
              title: Text(DateTime.now().toString()),
            ),
            Divider(),
            ListTile(
              onTap: () {},
              leading: Icon(Icons.category),
              title: Text('Choose Category'),
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
