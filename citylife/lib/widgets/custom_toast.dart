import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomToast {
  static void toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2),
        padding: EdgeInsets.symmetric(horizontal: 24.0),
      ),
    );
  }
}
