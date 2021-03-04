import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/services/shared_pref_service.dart';
import 'package:citylife/utils/constants.dart';
import 'package:citylife/utils/levels.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/utils/avatar.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = context.watch<AuthService>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: T.backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildImageAvatar(constraints.maxHeight / 4, context),
                  Spacer(),
                  buildExpBar(auth.authUser),
                  Spacer(),
                  buildProfileForm(auth.authUser),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  Spacer(),
                  buildSignOutButton(auth, context, constraints.maxWidth),
                  Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  GradientButton buildSignOutButton(
      AuthService auth, BuildContext context, double width) {
    return GradientButton(
      callback: () => auth.signOut(context),
      gradient: T.buttonGradient,
      increaseWidthBy: width,
      increaseHeightBy: 20.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Sign out",
          style: TextStyle(
            color: T.textLightColor,
            fontSize: 16.0,
          ),
        ),
      ),
      shadowColor: Colors.black.withOpacity(.25),
    );
  }

  Widget buildImageAvatar(double size, BuildContext context) {
    final authService = context.read<AuthService>();
    return Hero(
      tag: "avatar_selection",
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: GestureDetector(
          onTap: () async {
            final newAvatar = await buildAvatarDialog(context);
            if (newAvatar != null && newAvatar != authService.authUser.avatar) {
              try {
                CLUser user = authService.authUser;
                user.avatar = newAvatar;

                await UserAPIService.route("/update", body: user);
                // If everything went smoothly, then change the avatar
                final sp = await SharedPrefService.getInstance();
                await sp.setUserWith(spUserInfoKey, user);

                authService.authUser = user;
              } catch (e) {
                print("[Profile]::buildImageAvatar - $e");
              }
            }
          },
          child: Avatars.avatars[authService.authUser.avatar],
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
        content: Hero(
          tag: "avatar_selection",
          child: Container(
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
                      child: entry.value,
                    ),
                  ),
                );
              }).toList(),
            ),
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

  Widget buildProfileForm(CLUser user) {
    return Column(
      children: [
        TextFormField(
          initialValue: user.name,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.perm_identity),
          ),
        ),
        TextFormField(
          enabled: false,
          initialValue: "Am I a technical user?",
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.work_outline),
            suffix: Switch(
              value: user?.tech ?? false,
              onChanged: (val) {},
            ),
          ),
        )
      ],
    );
  }
}
