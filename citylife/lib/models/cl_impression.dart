import 'dart:convert';

import 'package:flutter/cupertino.dart';

class CLImpression extends ChangeNotifier {
  int id;
  int userId;
  String notes;
  List<String> images;
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
}
