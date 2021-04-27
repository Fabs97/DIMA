import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/screens/impressions/emotional/local_widget/emotionalForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../../utils/model_mocks.dart';

main() async {
  final impression = MockModel.getEmotional();
  group('Emotional Form - ', () {
    Widget testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider<CLImpression>.value(value: impression),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: EmotionalForm(),
        ),
      ),
    );

    testWidgets('check structure emotional form', (t) async {
      await t.pumpWidget(testApp);

      final listFinder = find.byType(ListView);
      expect(listFinder, findsOneWidget);
      await t.drag(listFinder, const Offset(0.0, -300));
      await t.pump();
    });
  });
}
