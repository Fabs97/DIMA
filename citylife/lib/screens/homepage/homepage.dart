import 'package:citylife/screens/home/home.dart';
import 'package:citylife/screens/profile/profile.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> pages = [
    Home(),
    Placeholder(),
    Placeholder(),
    Placeholder(),
    Profile(),
  ];
  int _selectedItem = 0;

  final List<IconData> icons = [
    Icons.map_outlined,
    Icons.list_sharp,
    Icons.add_circle_outline,
    Icons.star_outline,
    Icons.person_outline,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar(),
      body: pages[_selectedItem],
    );
  }

  Widget buildBottomNavigationBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: T.primaryColor,
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedItem,
        onTap: (index) {
          setState(() {
            _selectedItem = index;
          });
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: T.selectedBottomNavBarIconTheme,
        unselectedIconTheme: T.unselectedBottomNavBarIconTheme,
        iconSize: 39,
        items: icons.map((icon) {
          return BottomNavigationBarItem(
            icon: Icon(
              icon,
              size: 39,
            ),
            label: "",
          );
        }).toList(),
      ),
    );
  }
}
