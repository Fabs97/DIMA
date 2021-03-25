import 'package:citylife/screens/impressions_map/local_widgets/map_helper.dart';
import 'package:citylife/screens/impressions_map/local_widgets/map_marker.dart';
import 'package:citylife/screens/impressions_map/local_widgets/my_markers_state.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class HomeArguments {
  final double latMin;
  final double latMax;
  final double longMin;
  final double longMax;

  HomeArguments(this.latMin, this.latMax, this.longMin, this.longMax);
}

class ImpressionsMap extends StatefulWidget {
  ImpressionsMap({Key key}) : super(key: key);

  @override
  ImpressionsMapState createState() => ImpressionsMapState();
}

class ImpressionsMapState extends State<ImpressionsMap> {
  HomeArguments args;
  LatLng _center = LatLng(45.465086, 9.189747);
  GoogleMapController _controller;
  Location _location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  double _currentZoom = 15;
  Set<Circle> _circles;

  int _minClusterZoom = 0;
  int _maxClusterZoom = 19;
  Fluster<MapMarker> _clusterManager;

  // Future<void> _updateMarkers([double updatedZoom]) async {
  //   if (_clusterManager == null || position.zoom == _currentZoom) return;

  //   _currentZoom = position.zoom;

  //   final updatedMarkers = await MapHelper.getClusterMarkers(
  //     _clusterManager,
  //     _currentZoom,
  //     80,
  //   );

  //   _markers = updatedMarkers.toSet();
  // }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _checkLocationPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await _location.getLocation();
    _center = LatLng(_locationData.latitude, _locationData.longitude);

    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _center,
          zoom: _currentZoom,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Consumer<MyMarkersState>(
        builder: (_, state, __) => Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: _currentZoom,
              ),
              mapType: MapType.normal,
              myLocationEnabled: true,
              tiltGesturesEnabled: false,
              myLocationButtonEnabled: true,
              markers: state.googleMarkers,
              circles: _circles,
              onCameraMove: (position) async {
                if (_clusterManager == null || position.zoom == _currentZoom)
                  return;

                _currentZoom = position.zoom;

                final updatedMarkers = await MapHelper.getClusterMarkers(
                  _clusterManager,
                  _currentZoom,
                  80,
                );

                state.googleMarkers = updatedMarkers.toSet();
              },
              onMapCreated: (_cntlr) {
                _controller = _cntlr;
              },
              onCameraIdle: () {
                if (_controller != null) {
                  _controller.getVisibleRegion().then((bounds) async {
                    LatLng northEast = bounds.northeast;
                    LatLng southWest = bounds.southwest;

                    args = HomeArguments(southWest.latitude, northEast.latitude,
                        southWest.longitude, northEast.longitude);

                    _clusterManager = await MapHelper.initClusterManager(
                      state.markers,
                      _minClusterZoom,
                      _maxClusterZoom,
                    );

                    final updatedMarkers = await MapHelper.getClusterMarkers(
                      _clusterManager,
                      _currentZoom,
                      80,
                    );

                    state.googleMarkers = updatedMarkers.toSet();
                  });
                }
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  state.impressions = await ImpressionsAPIService.route(
                      "/byLatLong",
                      urlArgs: args);
                },
                child: Text("Retrieve info"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
