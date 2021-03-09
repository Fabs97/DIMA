import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ImpressionDetailState {
  List<String> _images = [];

  ImpressionDetailState(CLImpression impression, StorageService storage) {
    initState(impression, storage);
  }

  void initState(CLImpression impression, StorageService storage) async {
    // retrieve images from firebase storage
    List<DownloadTask> tasks = storage.downloadImageList(impression.images);
  }
}
