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
  }) {
    return CLUser(
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
  }
}
