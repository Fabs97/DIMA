class CLUser {
  int id;
  String firebaseId;
  bool tech;
  bool twofa;
  String name;
  double exp;
  String email;
  String password;
  String avatar;

  CLUser({
    this.id,
    this.firebaseId,
    this.tech,
    this.twofa,
    this.name,
    this.exp,
    this.email,
    this.password,
    this.avatar,
  });

  CLUser.fromJson(Map<String, dynamic> json) {
    this.id = json["id"] as int;
    this.firebaseId = json["firebaseId"] as String;
    this.tech = json["tech"] as bool ?? false;
    this.twofa = json["twofa"] as bool ?? false;
    this.name = json["name"] as String;
    this.exp = (json["exp"]).toDouble() ?? 0.0;
    this.email = json["email"] as String;
    this.password = json["password"] as String;
    this.avatar = json["avatar"] as String;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "firebaseId": this.firebaseId,
      "tech": this.tech ?? false,
      "twofa": this.twofa ?? false,
      "name": this.name,
      "exp": this.exp ?? 0.0,
      "email": this.email,
      "password": this.password,
      "avatar": this.avatar,
    };
  }
}
