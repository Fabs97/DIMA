import 'dart:async';
import 'dart:ui';

import 'package:citylife/screens/map_impressions/local_widgets/map_marker.dart';
import 'package:citylife/utils/theme.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHelper {
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
      if (mapMarker.isCluster) {
        mapMarker.icon = await _getClusterMarker(
          mapMarker.pointsSize,
          115,
        );
      } else {
        mapMarker.icon = await getIconMarker(mapMarker.id);
      }
      return mapMarker.toMarker();
    }).toList());
  }

  static Future<BitmapDescriptor> _getClusterMarker(
    int clusterSize,
    int width,
  ) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = Colors.cyan[300];
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    final double radius = width / 2;
    canvas.drawCircle(
      Offset(radius, radius),
      radius + 5,
      paint,
    );
    textPainter.text = TextSpan(
      text: clusterSize.toString(),
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: T.textLightColor,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        radius - textPainter.width / 2,
        radius - textPainter.height / 2,
      ),
    );
    final image = await pictureRecorder.endRecording().toImage(
          radius.toInt() * 2,
          radius.toInt() * 2,
        );
    final data = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  static Future<BitmapDescriptor> getIconMarker(String markerId) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()
      ..color = markerId[0] == 's' ? T.structuralColor : T.emotionalColor;

    final double radius = 40;
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      paint,
    );

    final image = await pictureRecorder.endRecording().toImage(
          radius.toInt() * 2,
          radius.toInt() * 2,
        );
    final data = await image.toByteData(format: ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }
}
