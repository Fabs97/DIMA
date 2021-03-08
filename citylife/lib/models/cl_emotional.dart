import 'dart:convert';

import 'package:flutter/cupertino.dart';

class CLEmotional extends ChangeNotifier {
  int id;
  int userId;
  int cleanness;
  int happiness;
  int inclusiveness;
  int confort;
  int safety;

  CLEmotional({
    this.id,
    this.userId,
    this.cleanness,
    this.happiness,
    this.inclusiveness,
    this.confort,
    this.safety,
  });

  String toJson() {
    return jsonEncode({
      "id": this.id,
      "userId": this.userId,
      "cleanness": this.cleanness ?? null,
      "happiness": this.happiness ?? null,
      "inclusiveness": this.inclusiveness ?? null,
      "confort": this.confort ?? null,
      "safety": this.safety ?? null,
    });
  }

  CLEmotional.fromJson(Map<String, dynamic> json) {
    this.id = json["id"] as int;
    this.userId = json["userId"] as int;
    this.cleanness = json["cleanness"] as int;
    this.happiness = json["happiness"] as int;
    this.inclusiveness = json["inclusiveness"] as int;
    this.confort = json["confort"] as int;
    this.safety = json["safety"] as int;
  }
}
