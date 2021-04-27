import 'package:citylife/screens/map_impressions/local_widgets/map_helper.dart';
import 'package:citylife/screens/map_impressions/local_widgets/map_marker.dart';
import 'package:citylife/screens/map_impressions/local_widgets/my_markers_state.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/custom_toast.dart';
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
  ImpressionsMap({Key key, this.testController}) : super(key: key);
  final GoogleMapController testController;
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

  int _minClusterZoom = 0;
  int _maxClusterZoom = 19;
  Fluster<MapMarker> _clusterManager;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  Future<LatLng> _checkLocationPermission() async {
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        throw new Exception("Could not enable location");
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw new Exception("Please grant access to location service");
      }
    }

    _locationData = await _location.getLocation();
    _center = LatLng(_locationData.latitude, _locationData.longitude);
    return _center;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
        future: _checkLocationPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Consumer2<MyMarkersState, ImpressionsAPIService>(
                builder: (_, state, impressionsAPIService, __) => Stack(
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
                      markers: state.googleMarkers ?? Set(),
                      onCameraMove: (position) async {
                        if (_clusterManager == null ||
                            position.zoom == _currentZoom) return;

                        _currentZoom = position.zoom;

                        final updatedMarkers =
                            await MapHelper.getClusterMarkers(
                          _clusterManager,
                          _currentZoom,
                          80,
                        );

                        state.googleMarkers = updatedMarkers.toSet();
                      },
                      onMapCreated: (cntrl) {
                        _controller = widget.testController ?? cntrl;
                      },
                      onCameraIdle: () async {
                        if (_controller != null) {
                          try {
                            await _controller
                                .getVisibleRegion()
                                .then((bounds) async {
                              LatLng northEast = bounds.northeast;
                              LatLng southWest = bounds.southwest;

                              args = HomeArguments(
                                  southWest.latitude,
                                  northEast.latitude,
                                  southWest.longitude,
                                  northEast.longitude);

                              if (state.isFirstMove) {
                                state.impressions = await impressionsAPIService
                                    .route("/byLatLong", urlArgs: args);
                              }

                              _clusterManager =
                                  await MapHelper.initClusterManager(
                                state.markers,
                                _minClusterZoom,
                                _maxClusterZoom,
                              );

                              final updatedMarkers =
                                  await MapHelper.getClusterMarkers(
                                _clusterManager,
                                _currentZoom,
                                80,
                              );

                              state.googleMarkers = updatedMarkers.toSet();

                              if (!state.isFirstMove) {
                                state.isButtonVisible = true;
                              } else {
                                state.isFirstMove = false;
                              }
                            });
                          } catch (e, sTrace) {
                            print(e);
                            print(sTrace);
                          }
                        }
                      },
                    ),
                    Visibility(
                      visible: state.isButtonVisible,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: T.structuralColor,
                              padding: const EdgeInsets.all(12.0),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(20.0),
                              ),
                            ),
                            onPressed: () async {
                              state.impressions = await impressionsAPIService
                                  .route("/byLatLong", urlArgs: args);

                              _clusterManager =
                                  await MapHelper.initClusterManager(
                                state.markers,
                                _minClusterZoom,
                                _maxClusterZoom,
                              );

                              final updatedMarkers =
                                  await MapHelper.getClusterMarkers(
                                _clusterManager,
                                _currentZoom,
                                80,
                              );

                              state.googleMarkers = updatedMarkers.toSet();

                              state.isButtonVisible = false;
                            },
                            child: Text("Retrieve info"),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            } else {
              CustomToast.toast(context, "Oops, something went wrong");
              return Container();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(T.primaryColor),
              ),
            );
          }
        },
      ),
    );
  }
}
