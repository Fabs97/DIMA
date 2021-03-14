import 'dart:convert';

import 'cl_impression.dart';

class CLStructural extends CLImpression {
  String component;
  String pathology;
  String typology;

  CLStructural({
    this.component,
    this.pathology,
    this.typology,
  });

  String toJson() {
    var data = super.toJsonMap();
    data["cleanness"] = this.component;
    data["happiness"] = this.pathology;
    data["typology"] = this.typology;

    return jsonEncode(data);
  }

  CLStructural.fromJson(Map<String, dynamic> json) {
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

    this.component = json["component"];
    this.pathology = json["pathology"];
    this.typology = json["typology"];
  }
}
