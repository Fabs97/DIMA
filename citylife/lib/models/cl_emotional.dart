import 'dart:convert';
import 'package:citylife/models/cl_impression.dart';

class CLEmotional extends CLImpression {
  int _cleanness;
  int get cleanness => this._cleanness;
  set cleanness(v) {
    this._cleanness = v;
    notifyListeners();
  }

  int _happiness;
  int get happiness => this._happiness;
  set happiness(v) {
    this._happiness = v;
    notifyListeners();
  }

  int _inclusiveness;
  int get inclusiveness => this._inclusiveness;
  set inclusiveness(v) {
    this._inclusiveness = v;
    notifyListeners();
  }

  int _comfort;
  int get comfort => this._comfort;
  set comfort(v) {
    this._comfort = v;
    notifyListeners();
  }

  int _safety;
  int get safety => this._safety;
  set safety(v) {
    this._safety = v;
    notifyListeners();
  }

  CLEmotional(
    this._cleanness,
    this._happiness,
    this._inclusiveness,
    this._comfort,
    this._safety, {
    id,
    userId,
    notes,
    images,
    latitude,
    longitude,
    timeStamp,
    placeTag,
    fromTech,
  }) : super(
          id: id,
          userId: userId,
          notes: notes,
          images: images,
          latitude: latitude,
          longitude: longitude,
          timeStamp: timeStamp,
          placeTag: placeTag,
          fromTech: fromTech,
        );

  String toJson() {
    var data = super.toJsonMap();
    data["cleanness"] = this._cleanness;
    data["happiness"] = this._happiness;
    data["inclusiveness"] = this._inclusiveness;
    data["comfort"] = this._comfort;
    data["safety"] = this._safety;

    return jsonEncode(data);
  }

  CLEmotional.fromJson(Map<String, dynamic> json) {
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

    this.cleanness = json["cleanness"] as int;
    this.happiness = json["happiness"] as int;
    this.inclusiveness = json["inclusiveness"] as int;
    this.comfort = json["comfort"] as int;
    this.safety = json["safety"] as int;
  }
}
