import 'dart:async';

import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/screens/home/local_widgets/my_markers_state.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum UploadStatus { Saving, Saved, Error }

class SaveImpression extends StatefulWidget {
  final bool isStructural;
  final CLImpression impression;
  final StorageService storageService;
  const SaveImpression(
      {Key key,
      @required this.isStructural,
      @required this.impression,
      @required this.storageService})
      : super(key: key);

  @override
  _SaveImpressionState createState() => _SaveImpressionState();
}

class _SaveImpressionState extends State<SaveImpression> {
  UploadStatus _uploadStatus = UploadStatus.Saving;

  void _saveImpression(CLImpression impression, StorageService storage) async {
    try {
      // Save to DB
      var savedImpression =
          await ImpressionsAPIService.route("/new", body: impression);
      if (savedImpression != null) {
        // Save images to storage
        Future.wait(storage.uploadImageList(impression is CLStructural,
                savedImpression.id, impression.images))
            .then((_) {
          setState(() => _uploadStatus = UploadStatus.Saved);
        }).catchError((e) {
          // Error while saving in storage
          setState(() {
            if (e.message == "Images list was found null") {
              _uploadStatus = UploadStatus.Saved;
            } else {
              _uploadStatus = UploadStatus.Error;
            }
          });
        });
      }
    } catch (e, sTrace) {
      // Error while saving impression
      setState(() {
        _uploadStatus = UploadStatus.Error;
      });
      print("${e.message}\n$sTrace");
    }
  }

  @override
  void initState() {
    _saveImpression(widget.impression, widget.storageService);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadStatus == UploadStatus.Saved) {
      Timer(const Duration(seconds: 1), () {
        Navigator.pop(context, widget.impression);
      });
    }
    return Center(
      child: <UploadStatus, Widget>{
        UploadStatus.Saving: SpinKitRipple(
          color: Colors.amber,
        ),
        UploadStatus.Saved: Icon(Icons.done_all_outlined),
        UploadStatus.Error: Icon(Icons.warning_amber_outlined),
      }[_uploadStatus],
    );
  }
}
