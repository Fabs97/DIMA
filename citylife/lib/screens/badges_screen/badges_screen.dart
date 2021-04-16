import 'package:citylife/models/cl_badges.dart';
import 'package:citylife/screens/badges_screen/badges_screen_state.dart';
import 'package:citylife/screens/badges_screen/local_widgets/badge_dialog.dart';
import 'package:citylife/screens/badges_screen/local_widgets/leaderboard.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/badge.dart';
import 'package:citylife/utils/hero_dialog_route.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/custom_gradient_button.dart';
import 'package:citylife/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthService, BadgeAPIService>(
      builder: (context, authService, badgeAPIService, __) =>
          ChangeNotifierProvider<BadgesScreenState>(
        create: (_) => BadgesScreenState(
          authService.authUser.id,
          badgeAPIService: badgeAPIService,
        ),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: BoxDecoration(
              gradient: T.backgroundColor,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return FutureBuilder(
                  future: badgeAPIService.route("/by",
                      urlArgs: authService.authUser.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        CustomToast.toast(context, snapshot.error.toString());
                        return Container();
                      } else {
                        CLBadge badge = snapshot.data;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Stack(
                            children: [
                              Container(
                                width: constraints.maxWidth,
                                height: constraints.maxHeight,
                                child: SafeArea(
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 30.0,
                                    crossAxisSpacing: 20.0,
                                    children: badge.badges.entries
                                        .map(
                                          (e) => GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                HeroDialogRoute(
                                                  builder: (_) => BadgeDialog(
                                                    acquired: e.value,
                                                    badge: e.key,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Hero(
                                              tag: e.key.toString(),
                                              child: Container(
                                                foregroundDecoration:
                                                    BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  color: e.value
                                                      ? Colors.transparent
                                                      : Colors.grey,
                                                  backgroundBlendMode:
                                                      BlendMode.saturation,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  image: DecorationImage(
                                                      image:
                                                          B.adges[e.key].image),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10.0,
                                right: 10.0,
                                left: 10.0,
                                child: CustomGradientButton(
                                  titleWidget: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Icon(
                                        Icons.emoji_events_outlined,
                                        size: 32.0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Text(
                                          "Leaderboard",
                                          style: TextStyle(
                                            color: T.textLightColor,
                                            fontSize: 20.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  callback: () {
                                    showAnimatedDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      animationType:
                                          DialogTransitionType.rotate3D,
                                      builder: (_) => Leaderboard(),
                                    );
                                  },
                                  width: constraints.maxWidth * .6,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(T.primaryColor),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
