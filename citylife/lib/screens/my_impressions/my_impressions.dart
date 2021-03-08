import 'package:citylife/screens/my_impressions/local_widgets/impression_card.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';

import '../../models/cl_emotional.dart';

class MyImpressions extends StatelessWidget {
  final List<Widget> _items = List.generate(
    20,
    (index) => ImpressionCard(
      impression: CLEmotional(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: T.backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: _items[index],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
