import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/screens/homepage/homepage.dart';
import 'package:citylife/screens/impressions/structural/local_widget/structuralForm.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/littleMap.dart';
import 'package:citylife/widgets/saveImpression.dart';
import 'package:citylife/widgets/sharedForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:steps_indicator/steps_indicator.dart';

class StructuralImpression extends StatefulWidget {
  @override
  _StructuralImpressionState createState() => _StructuralImpressionState();
}

class _StructuralImpressionState extends State<StructuralImpression> {
  final List<Widget> steps = [];
  final SharedForm _sharedForm = SharedForm(
    watchStructural: true,
  );
  int selectedStep = 0;
  int nbSteps = 4;
  CLStructural _impression = CLStructural();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CLStructural>.value(
      value: _impression,
      builder: (context, _) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                  })
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Column(
                  children: [
                    Container(
                        height: constraints.maxHeight * 0.4,
                        child: LittleMap(
                          watchStructural: true,
                        )),
                    Container(
                      height: constraints.maxHeight * 0.03,
                      width: constraints.maxWidth * 0.7,
                      child: Divider(
                        height: 50,
                        thickness: 3,
                        color: T.textDarkColor,
                      ),
                    ),
                    Container(
                        height: constraints.maxHeight * 0.45,
                        child: [
                          StructuralForm(),
                          _sharedForm,
                          SaveImpression(
                            isStructural: true,
                          ),
                        ].elementAt(selectedStep)),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StepsIndicator(
                              selectedStep: selectedStep,
                              nbSteps: nbSteps,
                              unselectedStepColorIn: T.emotionalColor,
                              unselectedStepColorOut: T.emotionalColor,
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
                            Consumer<CLStructural>(
                              builder: (_, impression, __) => Padding(
                                padding: const EdgeInsets.only(left: 45),
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
                                    style: TextStyle(color: T.textLightColor),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
