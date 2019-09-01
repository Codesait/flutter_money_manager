import 'package:flutter/material.dart';

Widget buildListInitialGuideWidget(String type) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.format_list_bulleted,
          size: 150.0,
        ),
        Text(
          'Once you add a new $type,'
          '\nyou\'ll see it listed here',
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
