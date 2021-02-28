import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomBottomAppBar {
  static BottomAppBar createBottomBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 60,
        color: T.primaryColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.map_outlined),
              onPressed: () {
                //navigate to home
              },
            ),
            IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.list_sharp),
              onPressed: () {
                //navigate to list of impression
              },
            ),
            IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.add_circle_outline),
              onPressed: () {
                //add impression
              },
            ),
            IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.star_outline),
              onPressed: () {
                //navigate to badge screen
              },
            ),
            IconButton(
              iconSize: 40.0,
              icon: Icon(Icons.person_outline),
              onPressed: () {
                //navigate to profile
              },
            )
          ],
        ),
      ),
    );
  }
}
