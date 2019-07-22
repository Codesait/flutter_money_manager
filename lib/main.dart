import 'package:flutter/material.dart';
import 'package:flutter_money_manager/navigatoins/navigation_provider.dart';
import 'package:provider/provider.dart';

import 'my_app.dart';

void main() => runApp(AppBase());

class AppBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: ThemeData
            .dark()
            .primaryColor,
      ),
      home: ChangeNotifierProvider<NavigationProvider>(
        builder: (_) => NavigationProvider(),
        child: MyApp(),
      ),
    );
  }
}
