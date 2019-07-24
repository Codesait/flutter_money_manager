import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.black,
      child: Text(
        'Settings',
        style:
            Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
      ),
    );
  }
}
