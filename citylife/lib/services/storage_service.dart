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

  Future<String> uploadImage(bool isStructural, int impressionId, File image,
      {Reference reference}) {
    // * /impressions/structural/3/<path>
    // * path is surely unique
    Reference ref = reference ??
        _instance
            .ref()
            .child("/impressions")
            .child("/${isStructural ? "structural" : "emotional"}")
            .child("/$impressionId")
            .child("/${basename(image.path)}");
    return ref.putFile(image).then((snapshot) => ref.getDownloadURL());
  }

  DownloadTask downloadFile(String url) {
    return _instance.ref(url).writeToFile(File('${appDocDir.path}/$url'));
  }

  List<Future<String>> uploadImageList(
      bool isStructural, int impressionId, List<File> images,
      {Reference reference}) {
        // TODO: if the error has to be changed, check the catch in the SaveImpression widget.
    if (images == null) throw new Exception("Images list was found null");
    final Reference ref = _instance
        .ref()
        .child("/impressions")
        .child("/${isStructural ? "structural" : "emotional"}")
        .child("/$impressionId");

    return images
        .map((image) => uploadImage(isStructural, impressionId, image,
            reference: reference ?? ref.child("/${basename(image.path)}")))
        .toList();
  }

  List<DownloadTask> downloadImageList(List<String> urls) {
    return urls.map((url) => downloadFile(url)).toList();
  }
}
