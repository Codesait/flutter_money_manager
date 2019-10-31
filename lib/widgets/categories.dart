import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_manager/models/category.dart';
import 'package:flutter_money_manager/storage_factory/database/category_table.dart';
import 'package:flutter_money_manager/utils/widget_util.dart';

import 'color_circle.dart';

class Categories extends StatelessWidget {
  final onTap; // use as function
  final bool shrinkWrap;

  Categories({
    Key key,
    @required this.onTap,
    this.shrinkWrap = false,
  })
      : assert(onTap != null),
        super(key: key);

  Widget _buildCategoryWidgets(List<Category> categories) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () => onTap(context, categories[index]),
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
