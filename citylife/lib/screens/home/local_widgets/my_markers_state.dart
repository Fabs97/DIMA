import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/screens/home/local_widgets/map_marker.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMarkersState with ChangeNotifier {
  List<CLImpression> _impressions = [];
  List<MapMarker> _markers = [];

  List<CLImpression> get impressions => _impressions;
  List<MapMarker> get markers => _markers;

  set impressions(v) {
    _impressions = v;
    _markers = List.from(v.map((i) => getMarker(i)).toList());
    notifyListeners();
  }

  MapMarker getMarker(CLImpression imp) {
    return MapMarker(
      id: imp is CLStructural
          ? "s" + imp.id.toString()
          : "c" + imp.id.toString(),
      position: LatLng(imp.latitude, imp.longitude),
    );
  }

  void add(CLImpression imp) {
    _impressions.add(imp);
    _markers.add(getMarker(imp));
    notifyListeners();
  }
}
