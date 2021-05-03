import 'package:citylife/screens/impressions/emotional/emotionalImpression.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';

import 'package:citylife/screens/impressions/structural/structuralImpression.dart';

class NewImpression extends StatefulWidget {
  @override
  _NewImpressionState createState() => _NewImpressionState();
}

enum NewImpressionChoice { Structural, Emotional }

class _NewImpressionState extends State<NewImpression> {
  NewImpressionChoice _newImpressionChoice;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: Key("newImpresssionDialog"),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: 13.5,
        vertical: 30.0,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: _newImpressionChoice == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      width: constraints.maxWidth * 0.8,
                      child: Text(
                        "Which kind of impression would you like to create?",
                        style: TextStyle(color: T.textDarkColor, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _newImpressionChoice =
                                NewImpressionChoice.Structural;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: T.structuralColor,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Structural",
                                  style: TextStyle(
                                      color: T.textLightColor, fontSize: 48),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 14.0),
                                child: Container(
                                  width: constraints.maxWidth * 0.8,
                                  child: Text(
                                    "Have you found a broken lamp or a problem with the street? Click here to let us know!",
                                    style: TextStyle(
                                        color: T.textLightColor, fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _newImpressionChoice =
                                NewImpressionChoice.Emotional;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: T.emotionalColor,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 14.0, bottom: 14.0),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Emotional",
                                  style: TextStyle(
                                      color: T.textLightColor, fontSize: 48),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 14.0),
                                child: Container(
                                  width: constraints.maxWidth * 0.8,
                                  child: Text(
                                    "Are you (un)happy with how your city looks like? Click here to let us know!",
                                    style: TextStyle(
                                        color: T.textLightColor, fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  ],
                )
              : _newImpressionChoice == NewImpressionChoice.Structural
                  ? StructuralImpression()
                  : EmotionalImpression(),
        ),
      ),
    );
  }
}
