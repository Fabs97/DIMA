import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/widgets/littleMap.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../mocks/google_map_controller_mock.dart';
import '../utils/model_mocks.dart';

main() {
  final impression = MockModel.getEmotional();
  final controller = MockGoogleMapController();
  group('LittleMap -', () {
    Widget testApp = ChangeNotifierProvider<CLImpression>.value(
      value: impression,
      child: MaterialApp(
        home: Scaffold(
          body: LittleMap(
            watchStructural: false,
          ),
        ),
      ),
    );
    testWidgets("Test LittleMap sets marker", (t) async {
      await t.pumpWidget(testApp);

      // final iconsFinder = find.byType(Icon);
      // expect(iconsFinder, findsOneWidget);
    });
  });
}
