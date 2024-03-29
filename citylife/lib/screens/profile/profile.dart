import 'dart:math';

import 'package:citylife/models/cl_user.dart';
import 'package:citylife/screens/login/2fa_login_state.dart';
import 'package:citylife/screens/profile/local_widgets/profile_two_factors_auth.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/services/shared_pref_service.dart';
import 'package:citylife/utils/badgeDialogState.dart';
import 'package:citylife/utils/constants.dart';
import 'package:citylife/utils/levels.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/utils/avatar.dart';
import 'package:citylife/widgets/custom_gradient_button.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';

import 'profile_state.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ConfettiController _confettiController;
  FocusNode _focusNode;
  UserAPIService _userAPIService;
  @override
  void dispose() {
    _confettiController?.dispose();
    super.dispose();
  }

  _unfocus() {
    _focusNode?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthService, UserAPIService>(
      builder: (context, auth, userAPIService, _) {
        _userAPIService = userAPIService;
        final CLUser user = auth.authUser;

        return ChangeNotifierProvider(
          create: (_) => ProfileState(user.name),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: T.backgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Consumer<ProfileState>(
                      builder: (context, state, _) {
                        return Consumer<BadgeDialogState>(
                          builder: (context, badgeDialog, _) => Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(),
                              Spacer(),
                              buildImageAvatar(
                                  constraints.maxHeight / 4, context),
                              buildExpBar(user),
                              Spacer(),
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: TextFormField(
                                        initialValue: user.name,
                                        focusNode: _focusNode,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.perm_identity,
                                            color: Colors.black,
                                            size: 26.0,
                                          ),
                                        ),
                                        onChanged: (v) {
                                          _unfocus();
                                          state.editedName = v;
                                          state.hasBeenEdited = true;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          border: Border.all(
                                            color: Colors.grey,
                                          ),
                                          color: Colors.grey[100],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Icon(
                                                  Icons.work_outline,
                                                  // color: T.textFieldIconColor,
                                                ),
                                              ),
                                              Text("Am I a technical user?"),
                                              Transform.rotate(
                                                angle: pi,
                                                child: GestureDetector(
                                                  onTap: () =>
                                                      showAnimatedDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    animationType:
                                                        DialogTransitionType
                                                            .fadeScale,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                        'What do you mean by "technical user"?',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      content: Text(techText),
                                                      actions: [
                                                        CustomGradientButton(
                                                          title: "Close",
                                                          callback: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .1,
                                                          height: 10.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 15.0,
                                                      right: 5.0,
                                                    ),
                                                    child: Icon(
                                                      Icons
                                                          .error_outline_rounded,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8.0),
                                                child: Switch(
                                                  value: user?.tech ?? false,
                                                  // * Disable switch if user is already a techie
                                                  onChanged:
                                                      !(user?.tech ?? false)
                                                          ? (_) async {
                                                              _unfocus();

                                                              var becomeTech =
                                                                  await showAnimatedDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                animationType:
                                                                    DialogTransitionType
                                                                        .fadeScale,
                                                                builder: (_) =>
                                                                    AlertDialog(
                                                                  title: Text(
                                                                    "Are you sure you want to become a technical user?",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                  content: Text(
                                                                      "You should know exactly what we mean by \"Technical User\"!\n$techText"),
                                                                  actions: [
                                                                    CustomGradientButton(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          .2,
                                                                      callback: () => Navigator.pop(
                                                                          context,
                                                                          true),
                                                                      title:
                                                                          "I'm a techie",
                                                                      height:
                                                                          10.0,
                                                                    ),
                                                                    CustomGradientButton(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          .2,
                                                                      callback: () => Navigator.pop(
                                                                          context,
                                                                          false),
                                                                      title:
                                                                          "Probably I'm not",
                                                                      height:
                                                                          10.0,
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                              if (becomeTech !=
                                                                  null) {
                                                                setState(() {
                                                                  state.hasBeenEdited =
                                                                      becomeTech;
                                                                  state.techEdited =
                                                                      becomeTech;
                                                                  user.tech =
                                                                      becomeTech;
                                                                });
                                                              }
                                                            }
                                                          : (_) {},
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: InkWell(
                                        onTap: () {
                                          _unfocus();

                                          setState(() {
                                            if (!user.twofa) {
                                              // user.twofa = true;
                                              state.hasBeenEdited = true;
                                            }
                                            showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    ProfileTwoFactorsAuth(
                                                      user: user,
                                                      userAPIService:
                                                          _userAPIService,
                                                    ));
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: Colors.grey,
                                            ),
                                            color: Colors.grey[100],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Icon(
                                                    (user?.twofa ?? false)
                                                        ? Icons.lock_outline
                                                        : Icons
                                                            .lock_open_outlined,
                                                  ),
                                                ),
                                                Text("2 Factor Authentication"),
                                                Spacer(),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Icon(
                                                    Icons
                                                        .keyboard_arrow_right_outlined,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Spacer(),
                              Spacer(),
                              Spacer(),
                              Spacer(),
                              !state.hasBeenEdited
                                  ? Consumer<TwoFALoginState>(
                                      builder: (context, state, _) =>
                                          CustomGradientButton(
                                        title: "Sign out",
                                        width: constraints.maxWidth,
                                        callback: () {
                                          state.authenticated = false;
                                          auth.signOut(context);
                                        },
                                      ),
                                    )
                                  : Consumer<BadgeAPIService>(
                                      builder: (context, badgeAPIService, _) =>
                                          CustomGradientButton(
                                        title: "Save profile",
                                        width: constraints.maxWidth,
                                        callback: () async {
                                          _unfocus();

                                          user.name = state.editedName;

                                          auth.authUser = await _userAPIService
                                              .route("/update", body: user);
                                          if (state.techEdited) {
                                            var badge =
                                                await badgeAPIService.route(
                                              "/techie",
                                              urlArgs: user.id,
                                            );
                                            if (badge != null) {
                                              badgeDialog.showBadgeDialog(
                                                badge,
                                                _confettiController =
                                                    ConfettiController(
                                                  duration:
                                                      Duration(milliseconds: 500),
                                                ),
                                                context
                                              );
                                            } 
                                          }
                                          state.hasBeenEdited = false;
                                        },
                                      ),
                                  ),
                              Spacer(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget buildImageAvatar(double size, BuildContext context) {
    final authService = context.read<AuthService>();
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: T.avatarBorderGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            image: DecorationImage(
              image: Avatars.avatars[authService.authUser.avatar],
              fit: BoxFit.cover,
            ),
          ),
          child: GestureDetector(
            onTap: () async {
              final newAvatar = await buildAvatarDialog(context);
              if (newAvatar != null &&
                  newAvatar != authService.authUser.avatar) {
                try {
                  CLUser user = authService.authUser;
                  user.avatar = newAvatar;

                  await _userAPIService.route("/update", body: user);
                  // If everything went smoothly, then change the avatar
                  final sp = await SharedPrefService.getInstance();
                  await sp.setUserWith(spUserInfoKey, user);

                  authService.authUser = user;
                } catch (e) {
                  print("[Profile]::buildImageAvatar - $e");
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Future buildAvatarDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Please choose your new Avatar!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: T.textDarkColor,
          ),
        ),
        content: Container(
          width: 10, // Needed just because
          child: GridView.count(
            crossAxisCount: 2,
            children: Avatars.avatars.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, entry.key);
                  },
                  child: Container(
                    child: Image(image: entry.value),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildExpBar(CLUser user) {
    final textStyle = TextStyle(
      color: T.textLightColor,
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    );

    final Level lvl = Levels.getLevelFrom(user.exp);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "LVL. ${lvl.number - 1}",
              style: textStyle,
            ),
            Text(
              "LVL. ${lvl.number}",
              style: textStyle,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LinearProgressIndicator(
            minHeight: 15.0,
            value: user.exp / lvl.maxExp,
            backgroundColor: Color(0xFFCA7F27).withOpacity(.5),
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFCA7F27)),
          ),
        ),
      ],
    );
  }
}
