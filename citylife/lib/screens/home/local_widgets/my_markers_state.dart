import 'package:citylife/models/cl_impression.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMarkersState with ChangeNotifier {
  List<CLImpression> _impressions = [];
  Set<Marker> _markers = Set();

  List<CLImpression> get impressions => _impressions;
  Set<Marker> get markers => _markers;

  set impressions(v) {
    _impressions = v;
    _markers = Set.from(v.map((i) => getMarker(i)).toList());
    notifyListeners();
  }

  Marker getMarker(CLImpression imp) {
    return Marker(
        markerId: MarkerId(imp.id.toString()),
        position: LatLng(imp.latitude, imp.longitude));
  }

  void add(CLImpression imp) {
    _impressions.add(imp);
    _markers.add(getMarker(imp));
    notifyListeners();
  }
}
