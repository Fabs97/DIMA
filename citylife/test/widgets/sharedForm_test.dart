import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/widgets/sharedForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../mocks/image_picker_mock.dart';
import '../utils/model_mocks.dart';

main() async {
  final impression = MockModel.getEmotional();
  final picker = MockImagePicker();
  group('sharedForm tests', () {
    Widget testApp = ChangeNotifierProvider<CLImpression>.value(
      value: impression,
      child: MaterialApp(
          home: Scaffold(
        body: SharedForm(
          watchStructural: false,
          picker: picker,
        ),
      )),
    );

    testWidgets('working path for adding an image to the gridView', (t) async {
      PickedFile file =
          new PickedFile('citylife\\assets\\images\\avatar_1.jpg');
      when(picker.getImage(
        source: ImageSource.gallery,
        preferredCameraDevice: CameraDevice.rear,
      )).thenAnswer((_) async => file);
      when(picker.getImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      )).thenAnswer((_) async => file);
      await t.pumpWidget(testApp);

      final gridViewFinder = find.byType(GridView);
      expect(gridViewFinder, findsOneWidget);
      final gridViewWidget = gridViewFinder.evaluate().first.widget as GridView;
      expect(gridViewWidget.semanticChildCount, 1);
      final iconFinder = find.descendant(
          of: gridViewFinder,
          matching: find.byIcon(Icons.add_a_photo_outlined));
      expect(iconFinder, findsOneWidget);
      await t.tapAt(t.getCenter(iconFinder));
      await t.pumpAndSettle();

      final bottomSheetFinder = find.byType(BottomSheet);
      expect(bottomSheetFinder, findsOneWidget);
      final listViewFinder = find.descendant(
          of: bottomSheetFinder, matching: find.byType(ListTile));
      expect(listViewFinder, findsNWidgets(2));
      final iconFinder2 = find.descendant(
          of: listViewFinder, matching: find.byIcon(Icons.photo_library));
      expect(iconFinder2, findsOneWidget);
      final iconFinder3 = find.descendant(
          of: listViewFinder, matching: find.byIcon(Icons.photo_camera));
      expect(iconFinder3, findsOneWidget);

      await t.tap(listViewFinder.first);
      await t.pumpAndSettle();
      expect(
          (find.byType(GridView).evaluate().first.widget as GridView)
              .semanticChildCount,
          2);

      await t.tapAt(t.getCenter(iconFinder));
      await t.pumpAndSettle();

      await t.tap(listViewFinder.last);
      await t.pumpAndSettle();
      expect(
          (find.byType(GridView).evaluate().first.widget as GridView)
              .semanticChildCount,
          3);
    });
  });
}
