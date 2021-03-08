import 'package:citylife/models/cl_emotional.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmotionalForm extends StatefulWidget {
  @override
  _EmotionalFormState createState() => _EmotionalFormState();
}

class _EmotionalFormState extends State<EmotionalForm> {
  double _value;
  @override
  Widget build(BuildContext context) {
    final emotionalImpression = context.watch<CLEmotional>();
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              width: constraints.maxWidth * 0.9,
              height: constraints.maxHeight,
              child: Column(
                children: [
                  Slider(
                    min: 0,
                    max: 100,
                    value: _value,
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ],
              ),
            ));
  }
}
