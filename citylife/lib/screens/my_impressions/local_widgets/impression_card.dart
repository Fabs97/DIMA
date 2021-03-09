import 'package:citylife/models/cl_structural.dart';
import 'package:citylife/screens/my_impressions/my_impressions_state.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/utils/emotional_utils.dart';
import 'package:flutter/material.dart';

import 'package:citylife/utils/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ImpressionCard extends StatelessWidget {
  final dynamic impression;

  const ImpressionCard({Key key, @required this.impression}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isStructural = impression is CLStructural;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Consumer<MyImpressionsState>(
          builder: (_, state, __) {
            return Dismissible(
              key: Key("${impression.id}"),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  return await showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text(
                            "Are you sure you want to delete this impression?"),
                        actions: [
                          ElevatedButton(
                            child: Text("No"),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          ElevatedButton(
                            child: Text("Yes"),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      );
                    },
                  );
                } else
                  return false;
              },
              onDismissed: (direction) async {
                // TODO: add try catch with toast
                try {
                  state.impressions = await ImpressionsAPIService.route(
                      isStructural ? "/structural" : "/emotional",
                      urlArgs: impression.id);
                } catch (e) {
                  print(e);
                }
              },
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
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
                              isStructural
                                  ? impression.component
                                  : DateFormat.yMMMMd("en_US")
                                      .format(impression.timeStamp),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: T.textLightColor,
                                fontSize: 24.0,
                              ),
                              maxLines: 1,
                            ),
                            isStructural
                                ? Text(
                                    impression.typology,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: T.textLightColor,
                                      fontSize: 18.0,
                                    ),
                                    maxLines: 1,
                                  )
                                : Row(
                                    children: [
                                      impression.cleanness,
                                      impression.happiness,
                                      impression.inclusiveness,
                                      impression.comfort,
                                      impression.safety,
                                    ]
                                        .map((e) => Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10.0,
                                              ),
                                              child: Icon(
                                                EUtils.getFrom(e),
                                                color: T.textLightColor,
                                              ),
                                            ))
                                        .toList(),
                                  ),
                            Text(
                              impression.placeTag,
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
                          color:
                              isStructural ? Colors.black54 : T.textLightColor,
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
      },
    );
  }
}
