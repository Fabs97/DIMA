import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';

class CLImpression extends ChangeNotifier {
  int id;
  int userId;
  String notes;
  List<File> images;
  double latitude;
  double longitude;
  DateTime timeStamp;
  String placeTag;

  CLImpression({
    this.notes,
    this.images,
    this.latitude,
    this.longitude,
    this.timeStamp,
    this.placeTag,
  });

  String toJson() {
    return jsonEncode(this.toJsonMap());
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "notes": this.notes,
      // "images": this.images.map((i) => null).toList(),
      "latitude": this.latitude,
      "longitude": this.longitude,
      "timeStamp": this.timeStamp.toString(),
      "placeTag": this.placeTag,
    };
  }

  CLImpression.fromJson(Map<String, dynamic> json) {
    this.id = json["id"] as int;
    this.userId = json["userId"] as int;
    this.notes = json["notes"] as String;
    // this.images = json["images"].cast<String>().toList();
    this.latitude = json["latitude"] as double;
    this.longitude = json["longitude"] as double;
    if (json["created"] != null) {
      this.timeStamp = DateTime.parse(json["created"] as String);
    }
    this.placeTag = json["place_tag"] as String;
  }
}
