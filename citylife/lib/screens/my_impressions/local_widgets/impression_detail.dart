import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/screens/my_impressions/local_widgets/impression_detail_state.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:citylife/utils/emotional_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ImpressionDetail extends StatelessWidget {
  final dynamic impression;
  const ImpressionDetail({Key key, @required this.impression})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isStructural = impression is CLStructural;
    final LatLng impressionSpot =
        LatLng(impression.latitude, impression.longitude);
    return Consumer<StorageService>(
      builder: (_, storageService, __) =>
          ChangeNotifierProvider<ImpressionDetailState>.value(
        value: ImpressionDetailState(impression, storageService),
        builder: (_, __) => Consumer<ImpressionDetailState>(
          builder: (_, state, __) => LayoutBuilder(
            builder: (_, constraints) => Consumer<StorageService>(
              builder: (_, service, __) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                insetPadding: EdgeInsets.all(0.0),
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: SingleChildScrollView(
                    child: Column(
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
                        // Place Tag
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17.5,
                            vertical: 8.0,
                          ),
                          child: TextFormField(
                            // initialValue: impression.placeTag,
                            enabled: false,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.pin_drop_outlined),
                                hintText: impression.placeTag,
                                contentPadding:
                                    const EdgeInsets.only(right: 8.0)),
                          ),
                        ),
                        Container(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 17.5),
                            child: Column(
                              children: isStructural
                                  ? ([
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                Icon(Icons.domain_outlined),
                                            hintText: impression.component,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            prefixIcon: Icon(
                                                Icons.help_outline_outlined),
                                            hintText: impression.pathology,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            prefixIcon:
                                                Icon(Icons.build_outlined),
                                            hintText: impression.typology,
                                          ),
                                        ),
                                      ),
                                    ])
                                  : {
                                      "Cleanness": impression.cleanness,
                                      "Happiness": impression.happiness,
                                      "Inclusiveness": impression.inclusiveness,
                                      "Comfort": impression.comfort,
                                      "Safety": impression.safety,
                                    }
                                      .map(
                                        (k, v) => MapEntry(
                                          k,
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.5,
                                                left: 20.5,
                                                bottom: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  k,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                                Icon(
                                                  EUtils.getFrom(v),
                                                  size: 35.0,
                                                  color: Colors.black54,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .values
                                      .toList(),
                            ),
                          ),
                        ),
                        // Notes
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17.5,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.edit_outlined),
                              hintText: impression.notes,
                              hintMaxLines: 5,
                            ),
                          ),
                        ),
                        // Images Grid
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            height: constraints.maxHeight * .2,
                            width: constraints.maxWidth * .9,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: state.images
                                    .map(
                                      (url) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          width: 100.0,
                                          height: 100.0,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(20.0),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(url),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // child: Image.network(url),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
