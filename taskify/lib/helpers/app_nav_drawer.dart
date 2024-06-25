import 'package:flutter/material.dart';
import 'package:taskify/screens/categories_screen.dart';
import 'package:taskify/screens/home_screen.dart';

import 'package:taskify/screens/todowithcategory.dart';
import 'package:taskify/service/category_service.dart';

class AppNavDrawer extends StatefulWidget {
  const AppNavDrawer({super.key});

  @override
  State<AppNavDrawer> createState() => _AppNavDrawerState();
}

class _AppNavDrawerState extends State<AppNavDrawer> {
  final List<Widget> _categoriesList = <Widget>[];
  @override
  void initState() {
    super.initState();
    getCategories();
  }

  getCategories() async {
    var categoryService = CategoryService();
    var categories = await categoryService.readCategory();

    categories.forEach((category) {
      setState(() {
        _categoriesList.add(ListTile(
          leading: Text(
            category['name'],
            style: const TextStyle(fontSize: 16),
          ),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  TodoWtihCategory(todoCategory: category['name']))),
        ));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(children: [
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Colors.lightBlue),
          currentAccountPicture: CircleAvatar(),
          accountName: Text("GulMuhammad"),
          accountEmail: Text("Gulm34545@gmail.comm"),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text("Home"),
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HomeScreen())),
        ),
        ListTile(
          leading: const Icon(Icons.list),
          title: const Text("Categories"),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CategoriesScreeen(),
            ),
          ),
        ),
        const Divider(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _categoriesList,
        )
      ]),
    );
  }
}
