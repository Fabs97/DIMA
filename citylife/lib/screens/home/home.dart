import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as ll;
import 'package:location/location.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  LatLng _center = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  double _zoom = 15;
  Set<Circle> _circles;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: _zoom,
            ),
            mapType: MapType.normal,
            myLocationEnabled: true,
            tiltGesturesEnabled: false,
            myLocationButtonEnabled: true,
            onMapCreated: _onMapCreated,
            onCameraIdle: _onCameraIde,
            circles: _circles,
          ),
        ],
      ),
    );
  }

  void _onCameraIde() {
    if (_controller != null) {
      _controller.getVisibleRegion().then((bounds) {
        LatLng northEast = bounds.northeast;
        LatLng southWest = bounds.southwest;

        final distance = ll.DistanceHaversine().as(
              ll.LengthUnit.Meter,
              ll.LatLng(northEast.latitude, northEast.longitude),
              new ll.LatLng(northEast.latitude, southWest.longitude),
            ) /
            2;

        setState(() {
          _circles = Set.from([
            Circle(
                circleId: CircleId("myCircle"),
                radius: distance * .95,
                center: _center,
                fillColor: Colors.amber,
                strokeColor: Colors.amber,
                onTap: () {
                  print('circle pressed');
                })
          ]);
        });
      });
    }
  }
}
