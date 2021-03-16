import 'package:citylife/utils/theme.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void toast(String msg, {bool short}) {
    var length = short == null
        ? Toast.LENGTH_SHORT
        : (short ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG);
    Fluttertoast.showToast(
      msg: msg,
      toastLength: length,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: T.structuralColor,
      textColor: T.textLightColor,
      fontSize: 16.0,
    );
  }
}
