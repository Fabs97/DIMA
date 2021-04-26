import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/screens/impressions/structural/local_widget/structuralForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../utils/model_mocks.dart';

main() async {
  final impression = MockModel.getStructural();
  final key = GlobalKey<FormState>();

  group('Structural Form - ', () {
    Widget testApp = MultiProvider(
      providers: [
        ChangeNotifierProvider<CLImpression>.value(value: impression),
      ],
      child: MaterialApp(
        home: Scaffold(body: StructuralForm(formKey: key)),
      ),
    );

    testWidgets('check empty structural form throw error', (t) async {
      await t.pumpWidget(testApp);

      final componentField = find.text('Component');
      expect(componentField, findsOneWidget);

      final pathologyField = find.text('Pathology');
      expect(pathologyField, findsOneWidget);

      final typeField = find.text('Type of Intervention');
      expect(typeField, findsOneWidget);

      expect(key.currentState.validate(), false);
    });

    testWidgets('check complete structural form working', (t) async {
      await t.pumpWidget(testApp);

      final componentField = find.text('Component');
      expect(componentField, findsOneWidget);
      // expect(componentField.evaluate().first.widget, isA<EditableText>());
      final fieldFinder = find.ancestor(
          of: componentField, matching: find.byType(TextFormField));
      expect(fieldFinder, findsOneWidget);
      await t.enterText(fieldFinder, "Test");
      await t.pumpAndSettle();

      final pathologyField = find.text('Pathology');
      expect(pathologyField, findsOneWidget);
      final pathFieldFinder = find.ancestor(
          of: pathologyField, matching: find.byType(TextFormField));
      expect(pathFieldFinder, findsOneWidget);
      await t.enterText(pathFieldFinder, 'Test');
      await t.pumpAndSettle();

      final typeField = find.text('Type of Intervention');
      expect(typeField, findsOneWidget);
      final dropdownFinder = find.ancestor(
          of: typeField, matching: find.byType(DropdownButtonFormField));
      expect(dropdownFinder, findsOneWidget);
      final items = find.byType(DropdownMenuItem);
      expect(items, findsNWidgets(5));
      await t.tap(dropdownFinder);
      await t.pumpAndSettle();
      await t.tapAt(t.getCenter(items.first));
      await t.pumpAndSettle();

      expect(key.currentState.validate(), true);
    });
  });
}
