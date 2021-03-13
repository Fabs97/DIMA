import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/utils/emotional_utils.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EmotionalForm extends StatefulWidget {
  @override
  _EmotionalFormState createState() => _EmotionalFormState();
}

class _EmotionalFormState extends State<EmotionalForm> {
  List<String> _titles = [
    "Cleanness",
    "Happiness",
    "Inclusiveness",
    "Comfort",
    "Safety"
  ];

  List<int> _sliderValue = [1, 1, 1, 1, 1];

  @override
  Widget build(BuildContext context) {
    final emotionalImpression = context.watch<CLEmotional>();
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              width: constraints.maxWidth * 0.7,
              height: constraints.maxHeight,
              child: ListView.builder(
                itemCount: _titles.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: constraints.maxHeight * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _titles[index],
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        Row(
                          children: [
                            Icon(
                              EUtils.getFrom(_sliderValue[index]),
                              color: T.textDarkColor,
                            ),
                            Container(
                              width: constraints.maxWidth * 0.64,
                              child: Slider(
                                activeColor: T.primaryColor,
                                min: 1,
                                max: 5,
                                divisions: 5,
                                value: _sliderValue[index].toDouble(),
                                onChanged: (value) {
                                  setState(() {
                                    _sliderValue[index] = value.toInt();
                                    switch (_titles[index]) {
                                      case "Cleanness":
                                        return emotionalImpression.cleanness =
                                            value.toInt();
                                      case "Happiness":
                                        return emotionalImpression.happiness =
                                            value.toInt();
                                      case "Inclusiveness":
                                        return emotionalImpression
                                            .inclusiveness = value.toInt();
                                      case "Comfort":
                                        return emotionalImpression.comfort =
                                            value.toInt();
                                      case "Safety":
                                        return emotionalImpression.safety =
                                            value.toInt();
                                      default:
                                        throw Exception(
                                            "Value not defined in emotional range");
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ));
  }
}
