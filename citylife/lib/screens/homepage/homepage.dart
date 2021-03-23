import 'package:citylife/screens/home/home.dart';
import 'package:citylife/screens/home/local_widgets/my_markers_state.dart';
import 'package:citylife/screens/impressions/newImpression.dart';
import 'package:citylife/screens/my_impressions/my_impressions.dart';
import 'package:citylife/screens/profile/profile.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MyMarkersState(),
      child: Scaffold(
        bottomNavigationBar: buildBottomNavigationBar(context),
        body: [
          Home(),
          MyImpressions(),
          Container(), // ! required for the correct positioning of the widgets
          Container(
            child: GestureDetector(
              onTap: () => CustomToast.toast(context, "Ciao"),
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
      child: Consumer<MyMarkersState>(
        builder: (_, state, __) => BottomNavigationBar(
          currentIndex: _selectedItem,
          onTap: (index) async {
            if (index != 2) {
              setState(() {
                _selectedItem = index;
              });
            } else {
              var result = await showDialog(
                context: context,
                builder: (context) => NewImpression(),
              );
              if (result != null) {
                state.add(result);
              }
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
      ),
    );
  }
}
