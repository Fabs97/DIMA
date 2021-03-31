import 'package:citylife/screens/badges_screen/badges_screen.dart';
import 'package:citylife/screens/impressions/newImpression.dart';
import 'package:citylife/screens/map_impressions/local_widgets/my_markers_state.dart';
import 'package:citylife/screens/map_impressions/map_impressions.dart';
import 'package:citylife/screens/my_impressions/my_impressions.dart';
import 'package:citylife/screens/profile/profile.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/utils/badgeDialogState.dart';
import 'package:citylife/utils/constants.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/saveImpression.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final int userId;
  HomePage({
    Key key,
    @required this.userId,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedItem = 0;
  ConfettiController _controller;
  Badge _badge;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    var b = await BadgeAPIService.route("/login", urlArgs: widget.userId);
    if (b != null) {
      setState(() => _badge = b);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BadgeDialogState>(
      builder: (context, badgeDialog, _) {
        if (_badge != null) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            badgeDialog.showBadgeDialog(
              _badge,
              _controller = ConfettiController(
                duration: Duration(
                  milliseconds: 500,
                ),
              ),
            );
            _badge = null;
          });
        }
        return ChangeNotifierProvider(
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
                          setState(() => _badge = returnArgs.badge);
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
        );
      },
    );
  }
}
