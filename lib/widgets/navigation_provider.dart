import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_manager/fabs/fabs.dart';
import 'package:flutter_money_manager/routes/category_route.dart';
import 'package:flutter_money_manager/widgets/categories.dart';
import 'package:flutter_money_manager/widgets/home.dart';
import 'package:flutter_money_manager/widgets/trash.dart';
import 'package:flutter_money_manager/widgets/transactions.dart';

class NavigationProvider with ChangeNotifier {
  NavigationItem currentNav = NavigationItem.HOME;

  Widget get getNav {
    switch (currentNav) {
      case NavigationItem.TRANSACTIONS:
        return Report();
      case NavigationItem.CATEGORIES:
        return Categories(
          onTap: (context, category) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CategoryRoute(category: category)));
          },
        );
      case NavigationItem.TRASH:
        return Trash();
      default:
        return Home();
    }
  }

  Widget getAppBarTitle() {
    switch (currentNav) {
      case NavigationItem.TRANSACTIONS:
        return Text('Transactions');
      case NavigationItem.CATEGORIES:
        return Text('Categories');
      case NavigationItem.TRASH:
        return Text('Trash');
      default:
        // Do not show title in Home.
        return Text('');
    }
  }

  Widget getFab(BuildContext context) {
    switch (currentNav) {
      case NavigationItem.CATEGORIES:
        return Fab().categoryFab(context);
      default:
        return Fab().transactionFab(context);
    }
  }

  void changeNavigation(NavigationItem newNav) {
    currentNav = newNav;
    notifyListeners();
  }
}

enum NavigationItem { HOME, TRANSACTIONS, CATEGORIES, TRASH }
