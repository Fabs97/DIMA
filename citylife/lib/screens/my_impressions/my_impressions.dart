import 'package:citylife/screens/my_impressions/local_widgets/impression_card.dart';
import 'package:citylife/screens/my_impressions/my_impressions_state.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyImpressions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = context.watch<AuthService>();

    return ChangeNotifierProvider(
      create: (_) => MyImpressionsState(auth.authUser.id),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (_, constraints) {
            return Container(
              decoration: BoxDecoration(
                gradient: T.backgroundColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Consumer<MyImpressionsState>(
                    builder: (_, state, __) {
                      return ListView.builder(
                        itemCount: state.impressions.length,
                        itemBuilder: (_, index) {
                          return ImpressionCard(
                            impression: state.impressions[index],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
