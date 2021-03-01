import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/levels.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';
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
      body: auth.authUser != null
          ? LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  decoration: BoxDecoration(
                    gradient: T.backgroundColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildImageAvatar(
                            constraints.maxWidth, constraints.maxHeight / 4),
                        // buildExpBar(auth.authUser),
                        buildProfileForm(auth.authUser),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            child: Text("Sign out"),
                            onPressed: () => auth.signOut(context),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildImageAvatar(double w, double h) {
    return Placeholder(
      fallbackWidth: w,
      fallbackHeight: h,
    );
  }

  Widget buildExpBar(CLUser user) {
    final Level lvl = Levels.getLevelFrom(user.exp);
    return LinearProgressIndicator(
      minHeight: 15.0,
      value: user.exp / lvl.maxExp,
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
              onChanged: (value) => setState(() {
                user.tech = value;
              }),
            ),
          ),
        )
      ],
    );
  }
}
