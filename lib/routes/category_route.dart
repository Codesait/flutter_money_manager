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
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _nameController = TextEditingController();
  final _category = Category(
    color: Colors.lime,
    transactionType: TransactionType.EXPENSE,
  );

  void _onRadioChanged(int value) {
    setState(() {
      _category.transactionType = TransactionType.valueOf(value);
    });
  }

  Future<void> _saveCategory() async {
    // Checking frontend validation.
    if (_formKey.currentState.validate()) {
      _category.name = _nameController.text;

      try {
        await CategoryTable().insert(_category);
        Navigator.pop(context);
      } catch (exception) {
        // TODO : give feedback to user
        print('_saveCategory() : Fail to save category! $exception');
      }
    }
  }

  Widget _buildColorPicker() {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return ColorTile(
          selected: _category.color == myConst.colors[index],
          color: myConst.colors[index],
          onTap: (color) {
            setState(() {
              _category.color = color;
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
        IconButton(icon: Icon(Icons.check), onPressed: () => _saveCategory()),
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
                color: _category.color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 8.0),
            Container(
              height: 42.0,
              child: _buildColorPicker(),
            ),
            SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                validator: (value) {
                  if (value
                      .trim()
                      .isEmpty) {
                    _nameController.text = '';
                    return 'Enter Category Name!';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio(
                      value: TransactionType.EXPENSE.value,
                      groupValue: _category.transactionType.value,
                      onChanged: _onRadioChanged,
                    ),
                    Text(TransactionType.EXPENSE.name),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio(
                      value: TransactionType.INCOME.value,
                      groupValue: _category.transactionType.value,
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
        accentColor: _category.color,
        cursorColor: _category.color,
        toggleableActiveColor: _category.color,
      ),
    );
  }
}
