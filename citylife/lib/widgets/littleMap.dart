import 'package:citylife/models/cl_impression.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class LittleMap extends StatefulWidget {
  @override
  _LittleMapState createState() => _LittleMapState();
}

class _LittleMapState extends State<LittleMap> {
  LatLng _center = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  double _zoom = 15;

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
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
          zoom: _zoom,
        ),
      ),
    );
  }

  // void _getAddress() async {
  //   final coordinates = new Coordinates(_center.latitude, _center.longitude);
  //   _address = await Geocoder.local.findAddressesFromCoordinates(coordinates);

  //   _first = _address.first.addressLine;
  // }

  @override
  Widget build(BuildContext context) {
    final structuralImpression = context.watch<CLImpression>();
    structuralImpression.latitude = _center.latitude;
    structuralImpression.latitude = _center.longitude;
    return LayoutBuilder(
      builder: (context, constraints) => Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Column(
          children: [
            Container(
              height: constraints.maxHeight * 0.8,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: _zoom,
                ),
                mapType: MapType.normal,
                myLocationEnabled: true,
                tiltGesturesEnabled: false,
                myLocationButtonEnabled: true,
                onMapCreated: _onMapCreated,
              ),
            ),
            Spacer(),
            Container(
              width: constraints.maxWidth * 0.9,
              child: TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on_outlined)),
                  initialValue:
                      "Lat: ${_center.latitude}, Long: ${_center.longitude}",
                  readOnly: true),
            ),
          ],
        ),
      ),
    );
  }
}