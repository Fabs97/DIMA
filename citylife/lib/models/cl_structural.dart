import 'dart:convert';
import 'package:flutter/cupertino.dart';

class CLStructural extends ChangeNotifier {
  int id;
  int userId;
  String component;
  String pathology;
  String typology;

  CLStructural(
      {this.id, this.userId, this.component, this.pathology, this.typology});

  String toJson() {
    return jsonEncode({
      "id": this.id,
      "userId": this.userId,
      "cleanness": this.component ?? null,
      "happiness": this.pathology ?? null,
      "typology": this.typology ?? null,
    });
  }

  CLStructural.fromJson(Map<String, dynamic> json) {
    this.id = json["id"] as int;
    this.userId = json["userId"] as int;
    this.component = json["component"];
    this.pathology = json["pathology"];
    this.typology = json["typology"];
  }
}
