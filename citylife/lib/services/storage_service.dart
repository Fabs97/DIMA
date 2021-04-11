import 'dart:io';
import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  FirebaseStorage _instance = FirebaseStorage.instance;

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

  Future<List<Future<String>>> dowloadImpressionImages(
      CLImpression impression) async {
    var list = await _instance
        .ref()
        .child("/impressions")
        .child("/${(impression is CLStructural) ? "structural" : "emotional"}")
        .child("/${impression.id}")
        .listAll();
    return list.items.map((e) => e.getDownloadURL()).toList();
  }
}
