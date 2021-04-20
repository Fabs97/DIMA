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

  MyImpressionsState(int userId, ImpressionsAPIService impressionsAPIService) {
    initState(userId, impressionsAPIService);
  }

  void initState(
      int userId, ImpressionsAPIService impressionsAPIService) async {
    impressions = await impressionsAPIService.route("/byUser", urlArgs: userId);
  }
}
