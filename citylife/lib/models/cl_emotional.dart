import 'dart:convert';
import 'package:citylife/models/cl_impression.dart';

class CLEmotional extends CLImpression {
  int cleanness;
  int happiness;
  int inclusiveness;
  int comfort;
  int safety;

  CLEmotional({
    this.cleanness,
    this.happiness,
    this.inclusiveness,
    this.comfort,
    this.safety,
  });

  String toJson() {
    var data = super.toJsonMap();
    data["cleanness"] = this.cleanness;
    data["happiness"] = this.happiness;
    data["inclusiveness"] = this.inclusiveness;
    data["comfort"] = this.comfort;
    data["safety"] = this.safety;

    return jsonEncode(data);
  }

  CLEmotional.fromJson(Map<String, dynamic> json) {
    this.id = json["id"] as int;
    this.userId = json["userId"] as int;
    this.notes = json["notes"] as String;
    this.images = json["images"].cast<String>().toList();
    this.latitude = json["latitude"] as double;
    this.longitude = json["longitude"] as double;
    if (json["created"] != null) {
      this.timeStamp = DateTime.parse(json["created"] as String);
    }
    this.placeTag = json["place_tag"] as String;

    this.cleanness = json["cleanness"] as int;
    this.happiness = json["happiness"] as int;
    this.inclusiveness = json["inclusiveness"] as int;
    this.comfort = json["comfort"] as int;
    this.safety = json["safety"] as int;
  }
}
