import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/badge.dart';
import 'package:citylife/utils/theme.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';

class BadgeDialogState {
  AuthService authService;
  BadgeDialogState(this.authService);

  void showBadgeDialog(badge, cont, context) {
    cont.play();
    authService.reloadUser();
    showAnimatedDialog(
      context: context,
      animationType: DialogTransitionType.fadeScale,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (_) => Dialog(
        key: Key("NewBadgeDialog"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: LayoutBuilder(
          builder: (_, constraints) => GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: constraints.maxWidth * .8,
              height: constraints.maxHeight * .8,
              decoration: BoxDecoration(boxShadow: null),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: constraints.maxWidth * .8,
                          height: constraints.maxWidth * .8,
                          decoration: BoxDecoration(
                            boxShadow: null,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: B.adges[badge].image,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: T.primaryColor,
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          child: Text(
                            "Congratulations for ${B.adges[badge].text}",
                            style: TextStyle(
                              color: T.textLightColor,
                              fontSize: 24,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: ConfettiWidget(
                      blastDirectionality: BlastDirectionality.explosive,
                      confettiController: cont,
                      particleDrag: 0.05,
                      numberOfParticles: 50,
                      gravity: .2,
                      shouldLoop: true,
                      colors: [
                        T.primaryColor,
                        T.textDarkColor,
                        T.textLightColor,
                        T.structuralColor,
                        T.emotionalColor,
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
