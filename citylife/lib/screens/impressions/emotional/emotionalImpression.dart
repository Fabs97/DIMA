import 'dart:io';

import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/screens/impressions/emotional/local_widget/emotionalForm.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/littleMap.dart';
import 'package:citylife/widgets/saveImpression.dart';
import 'package:citylife/widgets/sharedForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steps_indicator/steps_indicator.dart';

class EmotionalImpression extends StatefulWidget {
  @override
  _EmotionalImpressionState createState() => _EmotionalImpressionState();
}

class _EmotionalImpressionState extends State<EmotionalImpression> {
  List<File> imageList = [];
  SharedForm _sharedForm = SharedForm(
    watchStructural: false,
  );
  int selectedStep = 0;
  int nbSteps = 3;
  CLEmotional _impression = CLEmotional(1, 1, 1, 1, 1);
  LittleMap _map = LittleMap(
    watchStructural: false,
  );

  @override
  Widget build(BuildContext context) {
    if (_impression.userId == null) {
      var auth = context.read<AuthService>();
      _impression.userId = auth.authUser.id;
      _impression.fromTech = auth.authUser.tech;
    }
    return ChangeNotifierProvider<CLImpression>.value(
      value: _impression,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (_, constraints) => SingleChildScrollView(
            child: Consumer<CLImpression>(
              builder: (_, impression, __) {
                impression.placeTag = _map.placeTag;
                return Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: selectedStep == 2
                      ? Consumer3<StorageService, BadgeAPIService,
                          ImpressionsAPIService>(
                          builder: (_, storageService, badgeAPIService,
                                  impressionsAPIService, __) =>
                              Container(
                              height: constraints.maxHeight * 0.45,
                              child: [
                                EmotionalForm(),
                                _sharedForm,
                                SaveImpression(
                                  isStructural: true,
                                  impression: impression,
                                  storageService: storageService,
                                  badgeAPIService: badgeAPIService,
                                  impressionsAPIService:
                                          impressionsAPIService,
                                ),
                              ].elementAt(selectedStep)),
                        )
                      : ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.minHeight,
                            maxHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 5,
                                child: _map,
                              ),
                              Flexible(
                                flex: 5,
                                child: [
                                  EmotionalForm(),
                                  _sharedForm,
                                ].elementAt(selectedStep),
                              ),
                              Flexible(
                                flex: 1,
                                child: Align(
                                  alignment: FractionalOffset.bottomCenter,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StepsIndicator(
                                        selectedStep: selectedStep,
                                        nbSteps: nbSteps,
                                        unselectedStepColorIn: T.emotionalColor,
                                        unselectedStepColorOut:
                                            T.emotionalColor,
                                        selectedStepColorIn: T.structuralColor,
                                        selectedStepColorOut: T.structuralColor,
                                        doneLineColor: T.emotionalColor,
                                        doneStepColor: T.emotionalColor,
                                        undoneLineColor: T.emotionalColor,
                                        doneStepSize: 13,
                                        unselectedStepSize: 13,
                                        selectedStepSize: 13,
                                        lineLength: 40,
                                        enableLineAnimation: true,
                                        enableStepAnimation: true,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 45),
                                        child: MaterialButton(
                                          color: T.primaryColor,
                                          shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(20.0),
                                          ),
                                          onPressed: () {
                                            if (selectedStep < nbSteps) {
                                              setState(() {
                                                selectedStep++;
                                                if (selectedStep == 2) {
                                                  impression.images =
                                                      _sharedForm.imageList;
                                                }
                                              });
                                            }
                                          },
                                          child: Text(
                                            'Next',
                                            style: TextStyle(
                                                color: T.textLightColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
