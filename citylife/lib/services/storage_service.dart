import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  FirebaseStorage _instance = FirebaseStorage.instance;
  Directory appDocDir;

  StorageService() {
    initState();
  }

  initState() async {
    appDocDir = await getApplicationDocumentsDirectory();
  }

  UploadTask uploadImage(bool isStructural, String impressionId, File image,
      {Reference reference}) {
    Reference ref = reference ??
        _instance
            .ref()
            .child("/impressions")
            .child("/${isStructural ? "structural" : "emotional"}")
            .child("/$impressionId")
            .child("/${basename(image.path)}");
    return ref.putFile(image);
  }

  DownloadTask downloadFile(String url) {
    return _instance.ref(url).writeToFile(File('${appDocDir.path}/$url'));
  }

  List<UploadTask> uploadImageList(
      bool isStructural, String impressionId, List<File> images,
      {Reference reference}) {
    final Reference reference = _instance
        .ref()
        .child("/impressions")
        .child("/${isStructural ? "structural" : "emotional"}")
        .child("/$impressionId");

    return images
        .map((image) => uploadImage(isStructural, impressionId, image,
            reference:
                reference ?? reference.child("/${basename(image.path)}")))
        .toList();
  }

  List<DownloadTask> downloadImageList(List<String> urls) {
    return urls.map((url) => downloadFile(url)).toList();
  }
}
