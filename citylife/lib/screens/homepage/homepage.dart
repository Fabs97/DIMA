import 'package:citylife/screens/home/home.dart';
import 'package:citylife/screens/impressions/newImpression.dart';
import 'package:citylife/screens/my_impressions/my_impressions.dart';
import 'package:citylife/screens/profile/profile.dart';
import 'package:citylife/utils/badgeDialogState.dart';
import 'package:citylife/utils/constants.dart';
import 'package:citylife/utils/theme.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedItem = 0;
  ConfettiController controller;
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BadgeDialogState>(
      builder: (context, state, _) => Scaffold(
        bottomNavigationBar: buildBottomNavigationBar(context),
        body: [
          Home(),
          MyImpressions(),
          Container(), // ! required for the correct positioning of the widgets
          Container(
            child: GestureDetector(
              onTap: () => state.showBadgeDialog(
                Badge.Daily3,
                controller = ConfettiController(
                  duration: Duration(
                    milliseconds: 500,
                  ),
                ),
              ),
            ),
          ),
          Profile(),
        ].elementAt(_selectedItem),
      ),
    );
  }

  Widget buildBottomNavigationBar(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: T.primaryColor,
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedItem,
        onTap: (index) {
          if (index != 2) {
            setState(() {
              _selectedItem = index;
            });
          } else {
            showDialog(
              context: context,
              builder: (context) => NewImpression(),
            );
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedIconTheme: T.selectedBottomNavBarIconTheme,
        unselectedIconTheme: T.unselectedBottomNavBarIconTheme,
        type: BottomNavigationBarType.fixed,
        iconSize: 39,
        items: [
          Icons.map_outlined,
          Icons.list_sharp,
          Icons.add_circle_outline,
          Icons.star_outline,
          Icons.person_outline,
        ].map((icon) {
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
