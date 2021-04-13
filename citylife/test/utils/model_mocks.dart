import 'dart:io';

import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/models/cl_user.dart';

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
}
