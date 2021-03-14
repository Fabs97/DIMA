import 'package:citylife/models/cl_emotional.dart';
import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SaveImpression extends StatefulWidget {
  final bool isStructural;
  const SaveImpression({Key key, @required this.isStructural})
      : super(key: key);

  @override
  _SaveImpressionState createState() => _SaveImpressionState();
}

class _SaveImpressionState extends State<SaveImpression> {
  bool saved = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!saved) {
      final StorageService _storage = context.read<StorageService>();
      final CLImpression _impression = widget.isStructural
          ? context.watch<CLStructural>()
          : context.watch<CLEmotional>();
      Future.wait(_storage.uploadImageList(
              _impression is CLStructural, 1, _impression.images))
          .then((value) => setState(() {
                saved = true;
                print(value);
              }));
    }
    return Container();
  }
}
