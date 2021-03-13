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
      "images": this.images,
      "latitude": this.latitude,
      "longitude": this.longitude,
      "timeStamp": this.timeStamp.toString(),
      "placeTag": this.placeTag,
    };
  }

  // CLImpression.fromJson(Map<String, dynamic> json) {
  //   this.notes = json["notes"] as String;
  //   this.images = (json["images"]) as List<File>;
  //   this.latitude = json["latitude"] as double;
  //   this.longitude = json["longitude"] as double;
  //   if(json["timeStamp"])
  //   this.timeStamp = json["timeStamp"] as String;
  //   this.placeTag = json["placeTag"] as String;
  // }
}
