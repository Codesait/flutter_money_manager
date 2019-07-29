import 'package:flutter/material.dart';
import 'package:flutter_money_manager/consts.dart' as myConst;
import 'package:flutter_money_manager/models/category.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:flutter_money_manager/tiles/color_tile.dart';

import '../transaction_type.dart';

class CategoryRoute extends StatefulWidget {
  @override
  _CategoryRouteState createState() => _CategoryRouteState();
}

class _CategoryRouteState extends State<CategoryRoute> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _nameController = TextEditingController();

  Color _color = Colors.pink;
  TransactionType _transactionType = TransactionType.EXPENSE;

  void _onRadioChanged(int value) {
    setState(() {
      _transactionType = TransactionType.valueOf(value);
    });
  }

  Widget _buildColorPicker() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return ColorTile(
          selected: _color == myConst.colors[index],
          color: myConst.colors[index],
          onTap: (color) {
            setState(() {
              _color = color;
            });
          },
        );
      },
      itemCount: myConst.colors.length,
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
      title: Text('Category'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.check),
          onPressed: () {
            CategoryTable().insert(Category(
              color: _color,
              name: _nameController.text,
              transactionType: _transactionType,
            ));
            Navigator.pop(context);
          },
        ),
      ],
    );

    final body = SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: _color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 42.0,
              child: _buildColorPicker(),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Category Name',
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
                      groupValue: _transactionType.value,
                      onChanged: _onRadioChanged,
                    ),
                    Text(TransactionType.EXPENSE.name),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: TransactionType.INCOME.value,
                      groupValue: _transactionType.value,
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

    return Theme(
      child: Scaffold(
        appBar: appBar,
        body: body,
      ),
      data: Theme.of(context).copyWith(
        canvasColor: Theme
            .of(context)
            .primaryColor,
        accentColor: _color,
        cursorColor: _color,
        toggleableActiveColor: _color,
      ),
    );
  }
}
