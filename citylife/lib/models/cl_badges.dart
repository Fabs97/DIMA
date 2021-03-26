import 'package:citylife/utils/constants.dart';

class CLBadge {
  int id;
  int userId;
  Map<Badge, bool> badges;

  CLBadge({
    this.id,
    this.userId,
  }) {
    badges = Map<Badge, bool>();
  }

  CLBadge.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    badges = Map<Badge, bool>();
    badges[Badge.Daily3] = json['daily_3'] as bool;
    badges[Badge.Daily5] = json['daily_5'] as bool;
    badges[Badge.Daily10] = json['daily_10'] as bool;
    badges[Badge.Daily30] = json['daily_30'] as bool;
    badges[Badge.Techie] = json['technical'] as bool;
    badges[Badge.Structural1] = json['structural_1'] as bool;
    badges[Badge.Structural5] = json['structural_5'] as bool;
    badges[Badge.Structural10] = json['structural_10'] as bool;
    badges[Badge.Structural25] = json['structural_25'] as bool;
    badges[Badge.Structural50] = json['structural_50'] as bool;
    badges[Badge.Emotional1] = json['emotional_1'] as bool;
    badges[Badge.Emotional5] = json['emotional_5'] as bool;
    badges[Badge.Emotional10] = json['emotional_10'] as bool;
    badges[Badge.Emotional25] = json['emotional_25'] as bool;
    badges[Badge.Emotional50] = json['emotional_50'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['daily_3'] = this.badges[Badge.Daily3];
    data['daily_5'] = this.badges[Badge.Daily5];
    data['daily_10'] = this.badges[Badge.Daily10];
    data['daily_30'] = this.badges[Badge.Daily30];
    data['technical'] = this.badges[Badge.Techie];
    data['structural_1'] = this.badges[Badge.Structural1];
    data['structural_5'] = this.badges[Badge.Structural5];
    data['structural_10'] = this.badges[Badge.Structural10];
    data['structural_25'] = this.badges[Badge.Structural25];
    data['structural_50'] = this.badges[Badge.Structural50];
    data['emotional_1'] = this.badges[Badge.Emotional1];
    data['emotional_5'] = this.badges[Badge.Emotional5];
    data['emotional_10'] = this.badges[Badge.Emotional10];
    data['emotional_25'] = this.badges[Badge.Emotional25];
    data['emotional_50'] = this.badges[Badge.Emotional50];
    return data;
  }
}
