import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'categories.dart';
import 'home.dart';
import 'report.dart';
import 'settings.dart';

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

  void changeNavigation(NavigationItem newNav) {
    currentNav = newNav;
    notifyListeners();
  }
}

enum NavigationItem { HOME, REPORT, CATEGORIES, SETTINGS }
