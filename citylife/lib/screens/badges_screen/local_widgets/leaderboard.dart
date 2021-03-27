import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/utils/avatar.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/custom_toast.dart';
import 'package:flutter/material.dart';

class Leaderboard extends StatelessWidget {
  const Leaderboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: FutureBuilder(
        future: UserAPIService.route("/leaderboard"),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              CustomToast.toast(context, snapshot.error.toString());
              return Container();
            } else {
              var lb = snapshot.data;
              var size = MediaQuery.of(context).size;
              return Container(
                width: size.width * .8,
                height: size.height * .8,
                child: Column(
                  children: [
                    Icon(
                      Icons.emoji_events_outlined,
                      size: 32.0,
                    ),
                    Container(
                      width: size.width * .9,
                      height: size.height * .6,
                      child: ListView.builder(
                        itemCount: lb.length,
                        itemBuilder: (context, index) {
                          CLUser user = lb[index];
                          bool isTop3 = index >= 0 && index <= 2;
                          Color trophyColor;
                          double trophySize;
                          switch (index) {
                            case 0:
                              trophyColor = Colors.amber;
                              trophySize = 40.0;
                              break;
                            case 1:
                              trophyColor = Colors.blueGrey[300];
                              trophySize = 32.0;
                              break;
                            case 2:
                              trophyColor = Colors.brown[600];
                              trophySize = 24.0;
                              break;
                            default:
                              break;
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (isTop3)
                                Icon(
                                  Icons.emoji_events_outlined,
                                  color: trophyColor,
                                  size: trophySize,
                                ),
                              Container(
                                width: size.width * .1,
                                height: size.width * .1,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: Avatars.avatars[user.avatar],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Text(
                                user.name,
                                style: TextStyle(
                                  color: T.textDarkColor,
                                ),
                              ),
                              // Text(
                              //   "${user.exp.toInt()}",
                              //   style: TextStyle(
                              //     color: T.textDarkColor,
                              //   ),
                              // ),
                              if (isTop3)
                                Icon(
                                  Icons.emoji_events_outlined,
                                  color: trophyColor,
                                  size: trophySize,
                                ),
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            }
          } else
            return CircularProgressIndicator();
        },
      ),
    );
  }
}
