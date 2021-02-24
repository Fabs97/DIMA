import 'dart:ui';

import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';

class CustomBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path()..fillType = PathFillType.nonZero;
    Paint paint = Paint()
      ..color = Color(0xFF5FFFFF)
      ..maskFilter = MaskFilter.blur(BlurStyle.solid, 30.0)
      ..shader = LinearGradient(colors: [
        T.primaryColor,
        T.primaryColor,
      ]).createShader(Rect.largest);

    // * Change these values to bring the paint up or down
    final double y0 = size.height / 3;
    final double y3 = size.height / 12;

    final double diffQuart = (y0 - y3) / 4;
    final double yLCP = y0 - 3 * diffQuart;
    final double yRCP = y3 + 3 * diffQuart;

    final Point init = Point(0, y0);
    final Point leftCP = Point(size.width / 8, yLCP);
    final Point rightCP = Point((size.width * 7) / 8, yRCP);
    final Point topR = Point(size.width, y3);
    final Point botR = Point(size.width, size.height);
    final Point botL = Point(0, size.height);

    path.moveTo(init.x, init.y);
    path.cubicTo(leftCP.x, leftCP.y, rightCP.x, rightCP.y, topR.x, topR.y);
    path.lineTo(botR.x, botR.y);
    path.lineTo(botL.x, botL.y);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Point {
  final double x;
  final double y;

  Point(this.x, this.y);
}
