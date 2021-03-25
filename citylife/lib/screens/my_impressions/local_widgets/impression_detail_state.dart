import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:flutter/cupertino.dart';

class ImpressionDetailState with ChangeNotifier {
  List<String> _images = [];

  List<String> get images => _images;

  set images(v) {
    _images = v;
    notifyListeners();
  }

  ImpressionDetailState(CLImpression impression, StorageService storage) {
    initState(impression, storage);
  }

  void initState(CLImpression impression, StorageService storage) async {
    Future.wait(await storage.dowloadImpressionImages(impression))
        .then((urls) => images = urls);
  }
}
