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
    return AlertDialog(
      content: Container(
        width: 400.0,
        height: 900.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: badge.toString(),
              child: Container(
                width: 100.0,
                height: 100.0,
                foregroundDecoration: BoxDecoration(
                  color: acquired ? Colors.transparent : Colors.grey,
                  backgroundBlendMode: BlendMode.saturation,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: B.adges[badge].image,
                  ),
                ),
              ),
            ),
            Text(
              B.adges[badge].description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: T.textDarkColor,
              ),
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
