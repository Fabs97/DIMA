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

  testWidgets("Test CustomToast has context and valid message",
      (WidgetTester tester) async {
    await tester.pumpWidget(WidgetsApp(
      home: ScaffoldMessenger(
        child: Builder(builder: (BuildContext context) {
          CustomToast.toast(context, "Test message");
          expect(context, isNotEmpty);
          return Container();
        }),
      ),
      color: null,
    ));
    expect(find.byType(SnackBar), findsOneWidget);
  });
}
