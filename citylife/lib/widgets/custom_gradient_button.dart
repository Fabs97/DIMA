import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class CustomGradientButton extends StatefulWidget {
  final String title;
  final double width;
  final Function() callback;
  final Widget titleWidget;
  final EdgeInsets padding;
  final double height;
  CustomGradientButton({
    Key key,
    this.title,
    @required this.width,
    @required this.callback,
    this.titleWidget,
    this.padding,
    this.height,
  })  : assert(
          title != null || titleWidget != null,
          "Either title or titleWidget must be not null!",
        ),
        super(key: key);

  @override
  _CustomGradientButtonState createState() => _CustomGradientButtonState();
}

class _CustomGradientButtonState extends State<CustomGradientButton> {
  @override
  Widget build(BuildContext context) {
    return GradientButton(
      callback: widget.callback,
      gradient: T.buttonGradient,
      increaseWidthBy: widget.width,
      increaseHeightBy: widget.height ?? 20.0,
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(8.0),
        child: widget.titleWidget ??
            Text(
              widget.title,
              style: TextStyle(
                color: T.textLightColor,
                fontSize: 16.0,
              ),
            ),
      ),
      shadowColor: Colors.black.withOpacity(.25),
    );
  }
}
