import 'package:citylife/screens/home/local_widgets/map_helper.dart';
import 'package:citylife/screens/home/local_widgets/my_markers_state.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as ll;
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:citylife/screens/home/local_widgets/map_marker.dart';

class HomeArguments {
  final double latMin;
  final double latMax;
  final double longMin;
  final double longMax;

  HomeArguments(this.latMin, this.latMax, this.longMin, this.longMax);
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  HomeArguments args;
  LatLng _center = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  double _currentZoom = 15;
  Set<Circle> _circles;
  Set<Marker> _markers = Set();

  int _minClusterZoom = 0;
  int _maxClusterZoom = 19;
  Fluster<MapMarker> _clusterManager;

  Future<void> _updateMarkers([double updatedZoom]) async {
    if (_clusterManager == null || updatedZoom == _currentZoom) return;

    if (updatedZoom != null) {
      _currentZoom = updatedZoom;
    }

    final updatedMarkers = await MapHelper.getClusterMarkers(
      _clusterManager,
      _currentZoom,
      80,
    );

    _markers
      ..clear()
      ..addAll(updatedMarkers);
  }

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
      child: Stack(
        children: [
          Consumer<MyMarkersState>(
            builder: (_, state, __) => GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: _currentZoom,
              ),
              mapType: MapType.normal,
              myLocationEnabled: true,
              tiltGesturesEnabled: false,
              myLocationButtonEnabled: true,
              onCameraMove: (position) => _updateMarkers(position.zoom),
              onMapCreated: (_cntlr) {
                _controller = _cntlr;
              },
              markers: _markers,
              circles: _circles,
              onCameraIdle: () {
                if (_controller != null) {
                  _controller.getVisibleRegion().then((bounds) async {
                    LatLng northEast = bounds.northeast;
                    LatLng southWest = bounds.southwest;

                    final distance = ll.DistanceHaversine().as(
                          ll.LengthUnit.Meter,
                          ll.LatLng(northEast.latitude, northEast.longitude),
                          new ll.LatLng(
                              northEast.latitude, southWest.longitude),
                        ) /
                        2;

                    args = HomeArguments(southWest.latitude, northEast.latitude,
                        southWest.longitude, northEast.longitude);

                    state.impressions = await ImpressionsAPIService.route(
                        "/byLatLong",
                        urlArgs: args);

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

                    _markers
                      ..clear()
                      ..addAll(updatedMarkers);

                    // _circles = Set.from([
                    //   Circle(
                    //       circleId: CircleId("myCircle"),
                    //       radius: distance * .95,
                    //       center: _center,
                    //       fillColor: Colors.amber,
                    //       strokeColor: Colors.amber,
                    //       onTap: () {
                    //         print('circle pressed');
                    //       })
                    // ]);
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
