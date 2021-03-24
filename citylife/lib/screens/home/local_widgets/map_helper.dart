import 'dart:async';
import 'dart:ui';

import 'package:citylife/screens/home/local_widgets/map_marker.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHelper {
  /// Inits the cluster manager with all the [MapMarker] to be displayed on the map.
  /// Here we're also setting up the cluster marker itself, also with an [clusterImageUrl].
  ///
  /// For more info about customizing your clustering logic check the [Fluster] constructor.
  static Future<Fluster<MapMarker>> initClusterManager(
    List<MapMarker> markers,
    int minZoom,
    int maxZoom,
  ) async {
    assert(markers != null);
    assert(minZoom != null);
    assert(maxZoom != null);

    return Fluster<MapMarker>(
      minZoom: minZoom,
      maxZoom: maxZoom,
      radius: 150,
      extent: 1024,
      nodeSize: 64,
      points: markers,
      createCluster: (
        BaseCluster cluster,
        double lng,
        double lat,
      ) =>
          MapMarker(
        id: cluster.id.toString(),
        position: LatLng(lat, lng),
        isCluster: cluster.isCluster,
        clusterId: cluster.id,
        pointsSize: cluster.pointsSize,
        childMarkerId: cluster.childMarkerId,
      ),
    );
  }

  static Future<List<Marker>> getClusterMarkers(
    Fluster<MapMarker> clusterManager,
    double currentZoom,
    int clusterWidth,
  ) {
    assert(currentZoom != null);
    assert(clusterWidth != null);

    if (clusterManager == null) return Future.value([]);

    // [southwestLng, southwestLat, northeastLng, northeastLat]
    return Future.wait(clusterManager.clusters(
        [-180, -85, 180, 85], currentZoom.toInt()).map((mapMarker) async {
      return mapMarker.toMarker();
    }).toList());
  }
}
