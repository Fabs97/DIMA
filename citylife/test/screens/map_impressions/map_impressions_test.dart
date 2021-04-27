// import 'package:citylife/screens/map_impressions/local_widgets/my_markers_state.dart';
// import 'package:citylife/screens/map_impressions/map_impressions.dart';
// import 'package:citylife/services/api_services/impressions_api_service.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';

// import '../../mocks/api_services_mock.dart';
// import '../../mocks/my_markers_state_test.dart';
// import 'fake_map_controller.dart';

main() async {
//   final markers = MockMyMarkersState();
//   final impressionsAPIService = MockImpressionsAPIService();

//   TestWidgetsFlutterBinding.ensureInitialized();

//   final FakePlatformViewsController fakePlatformViewsController =
//       FakePlatformViewsController();

//   setUpAll(() {
//     SystemChannels.platform_views.setMockMethodCallHandler(
//         fakePlatformViewsController.fakePlatformViewsMethodHandler);
//   });

//   setUp(() {
//     fakePlatformViewsController.reset();
//   });
//   group('Map Impressions - ', () {
//     final _impressionsMap = ImpressionsMap();
//     Widget testApp = MultiProvider(
//       providers: [
//         ChangeNotifierProvider<MyMarkersState>.value(value: markers),
//         Provider<ImpressionsAPIService>.value(value: impressionsAPIService),
//       ],
//       child: MaterialApp(
//         home: Scaffold(
//           body: _impressionsMap,
//         ),
//       ),
//     );

//     testWidgets('test retrieve info button', (t) async {
//       await t.pumpWidget(testApp);
//       await t.pump();

//       final FakePlatformGoogleMap platformGoogleMap =
//           fakePlatformViewsController.lastCreatedView;

//       expect(platformGoogleMap.cameraPosition,
//           const CameraPosition(target: LatLng(45.465086, 9.189747)));
//     });
//   });
}

