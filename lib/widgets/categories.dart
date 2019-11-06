import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/category.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:flutter_money_manager/storage_factory/database/transaction_table.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';

import 'color_circle.dart';

class Categories extends StatefulWidget {
  final onTap; // use as function
  final bool shrinkWrap;

  Categories({
    Key key,
    @required this.onTap,
    this.shrinkWrap = false,
  })  : assert(onTap != null),
        super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Future<void> deleteCategory(BuildContext context, Category category) async {
    bool isCategoryExistInTransactionTable =
        await TransactionTable().isCategoryExist(category.id.toString());
    if (isCategoryExistInTransactionTable) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('${category.name} is using in transaction.')));

      return false;
    }

    int result = await CategoryTable().delete(category.id);
    if (result <= 0) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Fail to delete.')));

      return false;
    }

    setState(() {});

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Deleted successfully.')));
  }

  Widget _buildCategoryWidgets(List<Category> categories) {
    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () => widget.onTap(context, categories[index]),
          onLongPress: () => _showOptionsModalBottomSheet(
            context: context,
            category: categories[index],
          ),
          leading: ColorCircle(color: categories[index].color),
          title: Text(
            categories[index].name,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          trailing: Text(categories[index].transactionType.name),
        );
      },
      itemCount: categories.length,
    );
  }

  void _showOptionsModalBottomSheet({
    BuildContext context,
    Category category,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              new ListTile(
                  leading: new Icon(Icons.edit),
                  title: new Text('Edit'),
                  onTap: () {
                    Navigator.pop(context);
                    widget.onTap(context, category);
                  }),
              new ListTile(
                leading: new Icon(Icons.delete),
                title: new Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  deleteCategory(context, category);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: CategoryTable().getAll(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            if (snapshot.data.length > 0) {
              return _buildCategoryWidgets(snapshot.data);
            } else {
              return buildListInitialGuideWidget('category');
            }
          } else {
            return Center(child: new CircularProgressIndicator());
          }
        });
  }
}
