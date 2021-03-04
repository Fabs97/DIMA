import 'dart:convert';

import 'package:flutter/cupertino.dart';

class CLImpression extends ChangeNotifier {
  String notes;
  List<String> images;
  double latitude;
  double longitude;
  String timeStamp;
  String placeTag;

  CLImpression(
      {this.notes,
      this.images,
      this.latitude,
      this.longitude,
      this.timeStamp,
      this.placeTag});

  String toJson() {
    return jsonEncode({
      "notes": this.notes ?? null,
      "images": this.images ?? null,
      "latitude": this.latitude,
      "longitude": this.longitude,
      "timeStamp": this.timeStamp.toString(),
      "placeTag": this.placeTag,
    });
  }

  CLImpression.fromJson(Map<String, dynamic> json) {
    this.notes = json["notes"] as String;
    this.images = (json["images"]) as List<String>;
    this.latitude = json["latitude"] as double;
    this.longitude = json["longitude"] as double;
    this.timeStamp = json["timeStamp"] as String;
    this.placeTag = json["placeTag"] as String;
  }
}
