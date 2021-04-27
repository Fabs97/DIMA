import 'dart:async';

import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:citylife/utils/constants.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';

enum UploadStatus { Saving, Saved, Error }

class SaveImpression extends StatefulWidget {
  final bool isStructural;
  final CLImpression impression;
  final StorageService storageService;
  final BadgeAPIService badgeAPIService;
  final ImpressionsAPIService impressionsAPIService;
  const SaveImpression({
    Key key,
    @required this.isStructural,
    @required this.impression,
    @required this.storageService,
    @required this.badgeAPIService,
    @required this.impressionsAPIService,
  }) : super(key: key);

  @override
  _SaveImpressionState createState() => _SaveImpressionState();
}

class _SaveImpressionState extends State<SaveImpression> {
  UploadStatus _uploadStatus = UploadStatus.Saving;
  Badge badge;

  void _saveImpression(CLImpression impression, StorageService storage) async {
    try {
      // Save to DB
      var savedImpression =
          await widget.impressionsAPIService.route("/new", body: impression);
      badge = await widget.badgeAPIService.route(
        "/impression/${impression is CLEmotional ? "emotional" : "structural"}",
        urlArgs: impression.userId,
      );
      if (savedImpression != null) {
        // Save images to storage
        Future.wait(storage.uploadImageList(impression is CLStructural,
                savedImpression.id, impression.images))
            .then((_) async {
          setState(() => _uploadStatus = UploadStatus.Saved);
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
        Navigator.pop(
            context, SavedImpressionReturnArgs(widget.impression, badge));
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

class SavedImpressionReturnArgs {
  final CLImpression impression;
  final Badge badge;

  SavedImpressionReturnArgs(this.impression, this.badge);
}
