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

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              width: constraints.maxWidth * 0.7,
              height: constraints.maxHeight,
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _titles.length,
                  itemBuilder: (context, index) {
                    return Consumer<CLEmotional>(
                      builder: (_, emotionalImpression, __) => Container(
                        height: constraints.maxHeight * 0.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _titles[index],
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            Row(
                              children: [
                                Icon(
                                  EUtils.getFrom(_sliderValue[index]),
                                  color: T.textDarkColor,
                                ),
                                Container(
                                  width: constraints.maxWidth * 0.63,
                                  child: Slider(
                                    activeColor: T.primaryColor,
                                    min: 1,
                                    max: 5,
                                    divisions: 4,
                                    value: _sliderValue[index].toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        _sliderValue[index] = value.toInt();
                                        switch (_titles[index]) {
                                          case "Cleanness":
                                            {
                                              emotionalImpression.cleanness =
                                                  value.toInt();
                                              break;
                                            }
                                          case "Happiness":
                                            {
                                              emotionalImpression.happiness =
                                                  value.toInt();
                                              break;
                                            }
                                          case "Inclusiveness":
                                            {
                                              emotionalImpression
                                                      .inclusiveness =
                                                  value.toInt();
                                              break;
                                            }
                                          case "Comfort":
                                            {
                                              emotionalImpression.comfort =
                                                  value.toInt();
                                              break;
                                            }
                                          case "Safety":
                                            {
                                              emotionalImpression.safety =
                                                  value.toInt();
                                              break;
                                            }
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
                      ),
                    );
                  },
                ),
              ),
            ));
  }
}
