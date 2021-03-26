import 'package:citylife/screens/badges_screen/badges_screen.dart';
import 'package:citylife/screens/impressions/newImpression.dart';
import 'package:citylife/screens/impressions_map/impressions_map.dart';
import 'package:citylife/screens/impressions_map/local_widgets/my_markers_state.dart';
import 'package:citylife/screens/my_impressions/my_impressions.dart';
import 'package:citylife/screens/profile/profile.dart';
import 'package:citylife/utils/badgeDialogState.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/saveImpression.dart';
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
  ConfettiController _controller;
  
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BadgeDialogState>(
      builder: (context, badgeDialog, _) => ChangeNotifierProvider(
        create: (_) => MyMarkersState(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Theme(
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
                    SavedImpressionReturnArgs returnArgs = await showDialog(
                      context: context,
                      builder: (context) => Provider.value(
                        value: badgeDialog,
                        child: NewImpression(),
                      ),
                    );
                    if (returnArgs?.impression != null) {
                      state.add(returnArgs.impression);
                      if (returnArgs.badge != null) {
                        badgeDialog.showBadgeDialog(
                          returnArgs.badge,
                          _controller = ConfettiController(
                            duration: Duration(
                              milliseconds: 500,
                            ),
                          ),
                        );
                      }
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
          ),
          body: [
            ImpressionsMap(),
            MyImpressions(),
            Container(), // ! required for the correct positioning of the widgets
            BadgesScreen(),
            Profile(),
          ].elementAt(_selectedItem),
        ),
      ),
    );
  }
}
