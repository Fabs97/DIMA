import 'package:flutter/material.dart';

import 'package:citylife/utils/theme.dart';

import '../../../models/cl_emotional.dart';
import '../../../models/cl_structural.dart';

class ImpressionCard extends StatelessWidget {
  final dynamic impression;

  const ImpressionCard({Key key, @required this.impression}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isStructural = impression is CLStructural;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: Card(
            color: isStructural ? T.structuralColor : T.emotionalColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 32.0,
                        bottom: 32.0,
                        right: 12.0,
                      ),
                      child: Icon(
                        isStructural
                            ? Icons.warning_amber_outlined
                            : Icons.whatshot_outlined,
                        color: T.textLightColor,
                        size: 32.0,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          isStructural ? "Lamplight" : "10 May 2020",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: T.textLightColor,
                            fontSize: 24.0,
                          ),
                          maxLines: 1,
                        ),
                        isStructural
                            ? Text(
                                "Broken",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: T.textLightColor,
                                  fontSize: 18.0,
                                ),
                                maxLines: 1,
                              )
                            : Row(
                                children: [],
                              ),
                        Text(
                          "Piazza Leonardo Da Vinci, Milano, MI, 20131",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: T.textLightColor,
                            fontSize: 18.0,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.chevron_right,
                      color: isStructural ? Colors.black54 : T.textLightColor,
                      size: 49.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
