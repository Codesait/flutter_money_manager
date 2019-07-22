import 'package:flutter/material.dart';
import 'package:flutter_money_manager/navigatoins/navigation_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final nav = Provider.of<NavigationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Consumer<NavigationProvider>(
          builder: (context, navigationProvider, _) =>
              navigationProvider.getAppBarTitle(),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.of(context).pop();
                  nav.changeNavigation(NavigationItem.HOME);
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Report'),
                onTap: () {
                  Navigator.of(context).pop();
                  nav.changeNavigation(NavigationItem.REPORT);
                },
              ),
              ListTile(
                leading: Icon(Icons.category),
                title: Text('Categories'),
                onTap: () {
                  Navigator.of(context).pop();
                  nav.changeNavigation(NavigationItem.CATEGORIES);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  Navigator.of(context).pop();
                  nav.changeNavigation(NavigationItem.SETTINGS);
                },
              ),
            ],
          ),
        ),
      ),
      body: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, _) => navigationProvider.getNav,
      ),
      floatingActionButton: Consumer<NavigationProvider>(
        builder: (context, navigationProvider, _) =>
            navigationProvider.getFab(context),
      ),
    );
  }
}
