import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/screens/impressions_map/local_widgets/map_marker.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMarkersState with ChangeNotifier {
  List<CLImpression> _impressions = [];
  List<MapMarker> _markers = [];
  Set<Marker> _googleMarkers = Set();

  List<CLImpression> get impressions => _impressions;
  List<MapMarker> get markers => _markers;
  Set<Marker> get googleMarkers => _googleMarkers;

  set googleMarkers(v) {
    _googleMarkers = v;
    notifyListeners();
  }

  set impressions(v) {
    _impressions = v;
    _markers = List.from(v.map((i) => getMarker(i)).toList());
    _googleMarkers = Set.from(v.map((i) {
      var m = getMarker(i);
      return MapMarker(position: m.position, id: m.id).toMarker();
    }).toList());
    notifyListeners();
  }

  MapMarker getMarker(CLImpression imp) {
    return MapMarker(
      id: "${imp is CLStructural ? "s" : "c"}${imp.id}",
      position: LatLng(imp.latitude, imp.longitude),
    );
  }

  void add(CLImpression imp) {
    _impressions.add(imp);
    var marker = getMarker(imp);
    _markers.add(marker);
    _googleMarkers
        .add(MapMarker(position: marker.position, id: marker.id).toMarker());
    notifyListeners();
  }
}
