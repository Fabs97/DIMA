import 'dart:async';

import 'package:citylife/screens/login/2fa_login_state.dart';
import 'package:citylife/screens/login/backgroundPainter.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/custom_toast.dart';
import 'package:citylife/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class TwoFactorsAuthentication extends StatefulWidget {
  final int userId;
  TwoFactorsAuthentication({Key key, @required this.userId}) : super(key: key);

  @override
  _TwoFactorsAuthenticationState createState() =>
      _TwoFactorsAuthenticationState();
}

class _TwoFactorsAuthenticationState extends State<TwoFactorsAuthentication> {
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType> errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TwoFALoginState>(
      builder: (_, state, __) => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              decoration: BoxDecoration(
                gradient: T.backgroundColor,
              ),
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size.infinite,
                    foregroundPainter: CustomBackgroundPainter(),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: L.CityLife,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: Container(
                            width: constraints.maxWidth * .8,
                            child: Text(
                              "It seems like you have enabled 2 Factor Authentication",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: T.textLightColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                        Form(
                          key: formKey,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 8.0,
                            ),
                            child: Consumer2(
                              builder: (context, TwoFALoginState state,
                                      UserAPIService userAPIService, _) =>
                                  PinCodeTextField(
                                appContext: context,
                                pastedTextStyle: TextStyle(
                                  color: Colors.green.shade600,
                                  fontWeight: FontWeight.bold,
                                ),
                                length: 6,
                                backgroundColor: Colors.transparent,
                                animationType: AnimationType.fade,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(10),
                                  fieldHeight: 50,
                                  fieldWidth: 40,
                                  activeFillColor: Colors.transparent,
                                  activeColor: T.structuralColor,
                                  inactiveColor: T.structuralColor,
                                  selectedColor: T.textLightColor,
                                ),
                                cursorColor: T.structuralColor,
                                animationDuration: Duration(milliseconds: 300),
                                errorAnimationController: errorController,
                                controller: textEditingController,
                                errorAnimationDuration: 800,
                                keyboardType: TextInputType.number,
                                onCompleted: (v) async {
                                  var res = await userAPIService.route(
                                    "/2fa/postCode",
                                    urlArgs: widget.userId,
                                    body: v,
                                  );
                                  if (res) {
                                    state.authenticated = true;
                                  } else {
                                    CustomToast.toast(context,
                                        "Code is not correct, please try again");
                                  }
                                },
                                onChanged: (value) {
                                  setState(() {
                                    hasError = false;
                                    currentText = value;
                                  });
                                },
                                beforeTextPaste: (text) {
                                  if (double.tryParse(text) != null)
                                    return true;
                                  else
                                    return false;
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Container(
                            width: constraints.maxWidth * .8,
                            child: Text(
                              "Please input your pin from Google Authenticator",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: T.textLightColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
