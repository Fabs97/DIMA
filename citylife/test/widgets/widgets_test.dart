import 'package:citylife/widgets/custom_gradient_button.dart';
import 'package:citylife/widgets/custom_toast.dart';
import 'package:citylife/widgets/littleMap.dart';
import 'package:citylife/widgets/sharedForm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

main() {
  testWidgets("Test CustomGradientButton has valid title",
      (WidgetTester tester) async {
    await tester.pumpWidget(new MaterialApp(
      home: new CustomGradientButton(
        width: 0,
        callback: () {},
        title: "Test title",
      ),
    ));
    expect(find.text("Test title"), findsOneWidget);
  });

  testWidgets("Test CustomGradientButton throws exception",
      (WidgetTester tester) async {
    expect(
        () async => await tester.pumpWidget(new MaterialApp(
              home: new CustomGradientButton(
                width: 0,
                callback: () {},
              ),
            )),
        throwsAssertionError);
  });

  testWidgets("Test CustomToast has context and valid message",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Builder(builder: (BuildContext context) {
          // expect(context, isNotEmpty);
          return ElevatedButton(
            child: Placeholder(),
            onPressed: () => CustomToast.toast(context, "Test message"),
          );
        }),
      ),
      color: null,
    ));
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
