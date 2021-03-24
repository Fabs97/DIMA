import 'package:fluster/fluster.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

class MapMarker extends Clusterable {
  String id;
  LatLng position;
  Icon icon;

  MapMarker({
    @required this.id,
    @required this.position,
    this.icon,
    isCluster = false,
    clusterId,
    pointsSize,
    childMarkerId,
  }) : super(
          markerId: id,
          latitude: position.latitude,
          longitude: position.longitude,
          isCluster: isCluster,
          clusterId: clusterId,
          pointsSize: pointsSize,
          childMarkerId: childMarkerId,
        );

  Marker toMarker() => Marker(
        markerId: MarkerId(isCluster ? 'cl_$id' : id),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
      );
}
