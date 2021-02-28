import 'dart:collection';

import 'package:citylife/services/auth_service.dart';
import 'package:citylife/widgets/bottomAppbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng _initialCameraPosition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  Set<Circle> circles;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  void _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
      _locationData = await location.getLocation();
    }
    circles = Set.from([
      Circle(
          circleId: CircleId("myCircle"),
          radius: 100000,
          center: LatLng(_locationData.latitude, _locationData.longitude),
          fillColor: Color.fromRGBO(171, 39, 133, 0.1),
          strokeColor: Color.fromRGBO(171, 39, 133, 0.5),
          onTap: () {
            print('circle pressed');
          })
    ]);
  }

  Widget build(BuildContext context) {
    final _authInstance = context.read<AuthService>();
    return Scaffold(
        bottomNavigationBar: CustomBottomAppBar.createBottomBar(),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialCameraPosition),
                mapType: MapType.normal,
                myLocationEnabled: true,
                onMapCreated: _onMapCreated,
                circles: circles,
              ),
            ])));
  }
}
