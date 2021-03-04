import 'package:citylife/models/cl_user.dart';
import 'package:citylife/screens/login/backgroundPainter.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/logo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final AuthService auth = context.read<AuthService>();
    return Scaffold(
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
                SafeArea(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: constraints.maxHeight * .65,
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              bottom: 20.0,
                              right: 30.0,
                              left: 30.0,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  buildEmailFormField(),
                                  buildPasswordFormField(),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: T.textLightColor,
                                  endIndent: 10.0,
                                  indent: 10.0,
                                ),
                              ),
                              Text(
                                "or log in with",
                                style: TextStyle(color: T.textLightColor),
                              ),
                              Expanded(
                                child: Divider(
                                  color: T.textLightColor,
                                  endIndent: 10.0,
                                  indent: 10.0,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          // Login Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              buildSocialLoginButton(
                                L.Google,
                                () async {
                                  try {
                                    CLUser u = await auth.signInWithGoogle();
                                  } catch (e) {
                                    //TODO: implement catch statement
                                  }
                                },
                              ),
                              buildSocialLoginButton(
                                L.Twitter,
                                () async {
                                  try {
                                    CLUser u = await auth.signInWithTwitter();
                                  } catch (e) {
                                    //TODO: implement catch statement
                                  }
                                },
                              ),
                              buildSocialLoginButton(
                                L.GitHub,
                                () async {
                                  try {
                                    CLUser u =
                                        await auth.signInWithGitHub(context);
                                  } catch (e) {
                                    //TODO: implement catch statement
                                  }
                                },
                              ),
                              buildSocialLoginButton(
                                L.Facebook,
                                () async {
                                  try {
                                    CLUser u = await auth.signInWithFacebook();
                                  } catch (e) {
                                    //TODO: implement catch statement
                                  }
                                },
                              ),
                            ],
                          ),
                          Spacer(),
                          buildSignInButton(() async {
                            if (_formKey.currentState.validate()) {
                              try {
                                CLUser u =
                                    await auth.signInWithEmailAndPassword(
                                        _email, _password);
                              } catch (e) {
                                //TODO: implement catch statement
                              }
                            }
                          }, constraints.maxWidth),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildSignInButton(Function() buttonCallback, double width) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        right: 10.0,
        left: 10.0,
        bottom: 30.0,
      ),
      child: GradientButton(
        callback: buttonCallback,
        gradient: T.buttonGradient,
        increaseWidthBy: width,
        increaseHeightBy: 20.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Sign In",
            style: TextStyle(
              color: T.textLightColor,
              fontSize: 16.0,
            ),
          ),
        ),
        shadowColor: Colors.black.withOpacity(.25),
      ),
    );
  }

  Widget buildPasswordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        keyboardType: TextInputType.visiblePassword,
        initialValue: _password ?? "",
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          labelText: "Password",
          contentPadding: const EdgeInsets.all(8.0),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: T.textFieldIconColor,
            ),
          ),
        ),
        validator: (value) {
          if (value.isEmpty) return "Please input your password";

          return null;
        },
        onChanged: (value) {
          _password = value;
        },
      ),
    );
  }

  Widget buildEmailFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        initialValue: _email ?? "",
        decoration: InputDecoration(
          labelText: "Email",
          contentPadding: const EdgeInsets.all(8.0),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (email) {
          if (!EmailValidator.validate(email))
            return "Please input a valid email";
          return null;
        },
        onChanged: (email) => setState(() => _email = email),
      ),
    );
  }

  Widget buildSocialLoginButton(AssetImage logo, Function() callback,
      {double size = 100}) {
    return FloatingActionButton(
      backgroundColor: T.textLightColor,
      onPressed: callback,
      child: Image(
        image: logo,
        width: size,
        height: size,
        color: null,
      ),
    );
  }
}
