import 'package:citylife/utils/badge.dart';
import 'package:citylife/utils/constants.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';

class BadgeDialog extends StatelessWidget {
  final bool acquired;
  final Badge badge;
  const BadgeDialog({
    Key key,
    @required this.acquired,
    @required this.badge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return AlertDialog(
      content: Container(
        width: size.width * .9,
        height: size.height * .5,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: badge.toString(),
              child: Container(
                width: size.width * .5,
                height: size.width * .5,
                foregroundDecoration: BoxDecoration(
                  color: acquired ? Colors.transparent : Colors.grey,
                  backgroundBlendMode: BlendMode.saturation,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(image: B.adges[badge].image),
                ),
              ),
            ),
            Text(
              B.adges[badge].description,
              style: TextStyle(
                color: T.textDarkColor,
              ),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Got it!"),
            )
          ],
        ),
      ),
    );
  }
}
