class CLUser {
  int id;
  String firebaseId;
  bool tech;
  String name;
  double exp;
  String email;
  String password;

  CLUser({
    this.id,
    this.firebaseId,
    this.tech,
    this.name,
    this.exp,
    this.email,
    this.password,
  });

  CLUser.fromJson(Map<String, dynamic> json) {
    this.id = json["id"] as int;
    this.firebaseId = json["firebaseId"] as String;
    this.tech = json["tech"] as bool ?? false;
    this.name = json["name"] as String;
    this.exp = (json["exp"]).toDouble() ?? 0.0;
    this.email = json["email"] as String;
    this.password = json["password"] as String;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "firebaseId": this.firebaseId,
      "tech": this.tech ?? false,
      "name": this.name,
      "exp": this.exp ?? 0.0,
      "email": this.email,
      "password": this.password,
    };
  }
}
