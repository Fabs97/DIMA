import 'dart:io';

import 'package:citylife/models/cl_badges.dart';
import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/models/cl_user.dart';
import 'package:citylife/utils/constants.dart';

class MockModel {
  static CLUser getUser({
    id,
    firebaseId,
    tech,
    twofa,
    name,
    exp,
    email,
    password,
    avatar,
    noIdRequired = false,
  }) =>
      CLUser(
        id: noIdRequired ? null : id ?? 1,
        firebaseId: firebaseId ?? "firebaseId",
        tech: tech ?? false,
        twofa: twofa ?? false,
        name: name ?? "Tester Tester",
        exp: exp ?? 0.0,
        email: email ?? "tester@tester.test",
        password: password ?? "secret_password",
        avatar: avatar ?? "avatar_1",
      );

  static CLImpression getImpression({
    id,
    userId,
    notes,
    images,
    latitude,
    longitude,
    timeStamp,
    placeTag,
    fromTech,
  }) =>
      CLImpression(
        userId: userId ?? 1,
        notes: notes ?? "Test notes",
        images: images ?? <File>[],
        latitude: latitude ?? 0.0,
        longitude: longitude ?? 0.0,
        timeStamp: timeStamp ?? DateTime.now(),
        placeTag: placeTag ?? "Test Placetag",
        fromTech: fromTech ?? false,
      );

  static CLEmotional getEmotional({
    cleanness,
    happiness,
    inclusiveness,
    comfort,
    safety,
    id,
    userId,
    notes,
    images,
    latitude,
    longitude,
    timeStamp,
    placeTag,
    fromTech,
  }) =>
      CLEmotional(
        cleanness ?? 1,
        happiness ?? 1,
        inclusiveness ?? 1,
        comfort ?? 1,
        safety ?? 1,
        id: id ?? 1,
        userId: userId ?? 1,
        notes: notes ?? "Test notes",
        images: images ?? <File>[],
        latitude: latitude ?? 0.0,
        longitude: longitude ?? 0.0,
        timeStamp: timeStamp ?? DateTime.now(),
        placeTag: placeTag ?? "Test Placetag",
        fromTech: fromTech ?? false,
      );

  static CLStructural getStructural({
    component,
    pathology,
    typology,
    id,
    userId,
    notes,
    images,
    latitude,
    longitude,
    timeStamp,
    placeTag,
    fromTech,
  }) =>
      CLStructural(
        id: id ?? 1,
        userId: userId ?? 1,
        component: component ?? "Test Component",
        pathology: pathology ?? "Test Pathology",
        typology: typology ?? "Test Typology",
        notes: notes ?? "Test notes",
        images: images ?? <File>[],
        latitude: latitude ?? 0.0,
        longitude: longitude ?? 0.0,
        timeStamp: timeStamp ?? DateTime.now(),
        placeTag: placeTag ?? "Test Placetag",
        fromTech: fromTech ?? false,
      );
  static CLBadge getBadge({
    id,
    userId,
    daily3,
    daily5,
    daily10,
    daily30,
    techie,
    structural1,
    structural5,
    structural10,
    structural25,
    structural50,
    emotional1,
    emotional5,
    emotional10,
    emotional25,
    emotional50,
  }) =>
      CLBadge(
        id: id ?? 1,
        userId: userId ?? 1,
        badges: <Badge, bool>{
          Badge.Daily3: daily3 ?? false,
          Badge.Daily5: daily5 ?? false,
          Badge.Daily10: daily10 ?? false,
          Badge.Daily30: daily30 ?? false,
          Badge.Techie: techie ?? false,
          Badge.Structural1: structural1 ?? false,
          Badge.Structural5: structural5 ?? false,
          Badge.Structural10: structural10 ?? false,
          Badge.Structural25: structural25 ?? false,
          Badge.Structural50: structural50 ?? false,
          Badge.Emotional1: emotional1 ?? false,
          Badge.Emotional5: emotional5 ?? false,
          Badge.Emotional10: emotional10 ?? false,
          Badge.Emotional25: emotional25 ?? false,
          Badge.Emotional50: emotional50 ?? false,
        },
      );
}
