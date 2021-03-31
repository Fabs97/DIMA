import 'package:citylife/models/cl_badges.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:flutter/cupertino.dart';

class BadgesScreenState with ChangeNotifier {
  CLBadge _badge;
  CLBadge get badge => _badge;
  set badge(v) {
    _badge = v;
    notifyListeners();
  }

  BadgesScreenState(int userId) {
    initState(userId);
  }

  void initState(int userId) async {
    badge = await BadgeAPIService.route("/by", urlArgs: userId);
  }
}
