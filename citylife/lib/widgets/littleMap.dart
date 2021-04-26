import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/services/geocoding_service.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class LittleMap extends StatefulWidget {
  final bool watchStructural;
  String placeTag = "";

  LittleMap({Key key, @required this.watchStructural}) : super(key: key);
  @override
  _LittleMapState createState() => _LittleMapState();
}

class _LittleMapState extends State<LittleMap> {
  LatLng _center = LatLng(45.465086, 9.189747);
  GoogleMapController _controller;
  Location _location = new Location();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  double _zoom = 15;
  List<Marker> _markers = [];

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
    _controller?.dispose();
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
    setImpressionMarker();

    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _center,
          zoom: _zoom,
        ),
      ),
    );
  }

  void setImpressionMarker() {
    setState(() {
      _markers = [
        Marker(
          markerId: MarkerId("myImpression"),
          position: _center,
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CLImpression>(
      builder: (_, impression, __) {
        impression = widget.watchStructural
            ? impression as CLStructural
            : impression as CLEmotional;
        impression.latitude = _center.latitude;
        impression.longitude = _center.longitude;
        return LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.minHeight,
                maxHeight: constraints.maxHeight,
              ),
              child: Column(
                children: [
                  Flexible(
                    flex: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
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
                        onCameraMove: (position) => setState(
                          () {
                            _center = LatLng(position.target.latitude,
                                position.target.longitude);
                          },
                        ),
                        onCameraIdle: () async {
                          var placeTag = await GeocodingService.getAddressFrom(
                              _center.latitude, _center.longitude);
                          if (placeTag != null) {
                            impression.placeTag = placeTag ?? "";
                            widget.placeTag = impression.placeTag;
                          }
                          setImpressionMarker();
                        },
                        markers: Set.from(_markers),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        width: constraints.maxWidth * 0.9,
                        child: TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.pin_drop_outlined),
                            hintText: impression.placeTag ?? "",
                          ),
                          readOnly: true,
                          enabled: false,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      // height: constraints.maxHeight * 0.03,
                      width: constraints.maxWidth * 0.7,
                      child: Divider(
                        height: 50,
                        thickness: 3,
                        color: T.textDarkColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
