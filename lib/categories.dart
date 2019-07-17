import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.yellow,
      child: Text(
        'Categories',
        style:
            Theme.of(context).textTheme.display1.copyWith(color: Colors.white),
      ),
    );
  }
}
