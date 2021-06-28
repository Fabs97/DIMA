import 'dart:async';

import 'package:citylife/screens/map_impressions/local_widgets/map_helper.dart';
import 'package:citylife/screens/map_impressions/local_widgets/map_marker.dart';
import 'package:citylife/screens/map_impressions/local_widgets/my_markers_state.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/custom_toast.dart';
import 'package:fluster/fluster.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
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
  double _currentZoom = 15;
  StreamSubscription<Position> _positionStream;

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
    _positionStream?.cancel();
  }

  Future<LatLng> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    if (_positionStream == null) {
      _positionStream = Geolocator.getPositionStream(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      ).listen((Position position) {
        _center = LatLng(position.latitude, position.longitude);
      }, onError: (error) {
        print("error in _positionStream");
      });
    }
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
