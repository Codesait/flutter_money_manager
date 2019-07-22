import 'package:flutter/material.dart';

class TransactionRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Transaction'),
      ),
      body: Center(
        child: Text(
          'Transaction',
          style: Theme.of(context)
              .textTheme
              .display1
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
