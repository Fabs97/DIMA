import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ImpressionDetail extends StatelessWidget {
  final CLImpression impression;
  const ImpressionDetail({Key key, @required this.impression})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isStructural = impression is CLStructural;
    final LatLng impressionSpot =
        LatLng(impression.latitude, impression.longitude);
    return LayoutBuilder(
      builder: (context, constraints) => Consumer<StorageService>(
        builder: (context, service, _) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          contentPadding: EdgeInsets.all(0.0),
          content: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: constraints.maxHeight * .2,
                width: constraints.maxWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                  child: GoogleMap(
                    markers: Set.from([
                      Marker(
                        markerId: MarkerId("impressionPosition"),
                        position: impressionSpot,
                      )
                    ]),
                    initialCameraPosition: CameraPosition(
                      target: impressionSpot,
                      zoom: 15,
                    ),
                    tiltGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    onTap: (_) async {
                      // trigger open in maps
                      final String mapsUrl =
                          "https://www.google.com/maps/search/?api=1&query=${impression.latitude},${impression.longitude}";
                      if (await canLaunch(mapsUrl)) {
                        await launch(mapsUrl);
                      } else {
                        // TODO: implement toast with error
                        print('Could not open the map');
                      }
                    },
                  ),
                ),
              ),
              TextFormField(
                initialValue: impression.placeTag,
                enabled: false,
                decoration:
                    InputDecoration(icon: Icon(Icons.pin_drop_outlined)),
              ),
              // Place Tag
              // if (isStructural)
              //   Container(
              //     child: Text("Is Structural"),
              //   ),
              // if (!isStructural)
              //   Container(
              //     child: Text("!Is Structural"),
              //   ),
              // Notes
              // Images Grid
            ],
          ),
        ),
      ),
    );
  }
}
