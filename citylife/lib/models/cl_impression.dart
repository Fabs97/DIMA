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
  bool fromTech;

  CLImpression({
    this.id,
    this.userId,
    this.notes,
    this.images,
    this.latitude,
    this.longitude,
    this.timeStamp,
    this.placeTag,
    this.fromTech,
  });

  String toJson() {
    return jsonEncode(this.toJsonMap());
  }

  Map<String, dynamic> toJsonMap() {
    return {
      "id": this.id,
      "userId": this.userId,
      "notes": this.notes,
      "latitude": this.latitude,
      "longitude": this.longitude,
      "timeStamp": this.timeStamp.toString(),
      "placeTag": this.placeTag,
      "fromTech": this.fromTech,
    };
  }
}
