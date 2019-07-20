import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_money_manager/navigatoins/categories.dart';
import 'package:flutter_money_manager/navigatoins/home.dart';
import 'package:flutter_money_manager/navigatoins/report.dart';
import 'package:flutter_money_manager/navigatoins/settings.dart';
import 'package:flutter_money_manager/fabs/fabs.dart';

class NavigationProvider with ChangeNotifier {
  NavigationItem currentNav = NavigationItem.HOME;

  Widget get getNav {
    switch (currentNav) {
      case NavigationItem.REPORT:
        return Report();
      case NavigationItem.CATEGORIES:
        return Categories();
      case NavigationItem.SETTINGS:
        return Settings();
      default:
        return Home();
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

enum NavigationItem { HOME, REPORT, CATEGORIES, SETTINGS }
