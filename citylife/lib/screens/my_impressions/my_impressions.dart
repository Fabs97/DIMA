import 'package:citylife/screens/my_impressions/local_widgets/impression_card.dart';
import 'package:citylife/screens/my_impressions/my_impressions_state.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyImpressions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthService, ImpressionsAPIService>(
      builder: (context, auth, impressionsAPIService, __) =>
          ChangeNotifierProvider(
        create: (_) =>
            MyImpressionsState(auth.authUser.id, impressionsAPIService),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
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
                      builder: (_, state, __) => ListView.builder(
                        itemCount: state.impressions.length,
                        itemBuilder: (_, index) {
                          return ImpressionCard(
                            impression: state.impressions[index],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
