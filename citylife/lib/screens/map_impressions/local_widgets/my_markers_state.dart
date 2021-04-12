import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/screens/map_impressions/local_widgets/map_helper.dart';
import 'package:citylife/screens/map_impressions/local_widgets/map_marker.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMarkersState with ChangeNotifier {
  List<CLImpression> _impressions = [];
  List<MapMarker> _markers = [];
  Set<Marker> _googleMarkers = Set();
  bool _isButtonVisible = false;
  bool _isFirstMove = true;

  List<CLImpression> get impressions => _impressions;
  List<MapMarker> get markers => _markers;
  Set<Marker> get googleMarkers => _googleMarkers;
  bool get isButtonVisible => _isButtonVisible;
  bool get isFirstMove => _isFirstMove;

  set googleMarkers(v) {
    _googleMarkers = v;
    notifyListeners();
  }

  set isButtonVisible(v) {
    _isButtonVisible = v;
    notifyListeners();
  }

  set isFirstMove(v) {
    _isFirstMove = v;
    notifyListeners();
  }

  set impressions(v) {
    MapHelper.getIconMarker("s").then((structuralBitmap) =>
        MapHelper.getIconMarker("e").then((emotionalBitmap) {
          _impressions = v;
          _markers = List.from(v
              .map((i) => getMarker(
                    i,
                    bitmap:
                        i is CLStructural ? structuralBitmap : emotionalBitmap,
                  ))
              .toList());
          _googleMarkers = Set.from(v.map((i) {
            return getMarker(i,
                    bitmap:
                        i is CLStructural ? structuralBitmap : emotionalBitmap)
                .toMarker();
          }).toList());
          notifyListeners();
        }));
  }

  MapMarker getMarker(CLImpression imp, {BitmapDescriptor bitmap}) {
    return MapMarker(
      id: "${imp is CLStructural ? "s" : "e"}${imp.id}",
      position: LatLng(imp.latitude, imp.longitude),
      icon: bitmap,
    );
  }

  void add(CLImpression imp) async {
    _impressions.add(imp);
    var marker = getMarker(imp);
    marker.icon = await MapHelper.getIconMarker(marker.id);
    _markers.add(marker);
    _googleMarkers.add(marker.toMarker());
    notifyListeners();
  }
}
