import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:flutter/foundation.dart';

class MyImpressionsState with ChangeNotifier {
  List<CLImpression> _impressions = [];

  List<CLImpression> get impressions => _impressions;

  set impressions(v) {
    _impressions = v;
    notifyListeners();
  }

  MyImpressionsState(int userId) {
    initState(userId);
  }

  void initState(int userId) async {
    impressions = await ImpressionsAPIService.route("/byUser", urlArgs: userId);
  }
}
