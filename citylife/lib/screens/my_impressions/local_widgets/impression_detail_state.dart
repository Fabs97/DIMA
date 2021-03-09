import 'dart:io';

import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ImpressionDetailState with ChangeNotifier {
  List<String> _images = [];

  // TODO: this is extremely expensive, rethink it
  List<File> get images => _images
      .map(
        (imagePath) => File(imagePath),
      )
      .toList();

  set images(v) {
    _images = v;
    notifyListeners();
  }

  ImpressionDetailState(CLImpression impression, StorageService storage) {
    initState(impression, storage);
  }

  void initState(CLImpression impression, StorageService storage) async {
    // retrieve images from firebase storage
    // TODO: from this a list of paths must come out and be stored in this.images
    List<DownloadTask> tasks = storage.downloadImageList(impression.images);
  }
}
