import 'package:citylife/models/cl_user.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/utils/theme.dart';
import 'package:citylife/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileTwoFactorsAuth extends StatefulWidget {
  final UserAPIService userAPIService;
  final CLUser user;
  ProfileTwoFactorsAuth(
      {Key key, @required this.user, @required this.userAPIService})
      : super(key: key);

  @override
  _ProfileTwoFactorsAuthState createState() => _ProfileTwoFactorsAuthState();
}

class _ProfileTwoFactorsAuthState extends State<ProfileTwoFactorsAuth> {
  @override
  void initState() {
    init();
    super.initState();
  }

  String _secret;
  void init() {
    widget.userAPIService
        .route("/2fa/getSecret", urlArgs: widget.user.id)
        .then((secret) => setState(() => _secret = secret.replaceAll('"', "")));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: 13.5,
        vertical: 30.0,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_secret != null) {
            final String data =
                "otpauth://totp/${widget.user.email}?secret=$_secret&issuer=CityLife";
            return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: QrImage(
                      data: data,
                      version: QrVersions.auto,
                      size: constraints.maxWidth * .6,
                      backgroundColor: T.primaryColor,
                      eyeStyle: QrEyeStyle(
                        eyeShape: QrEyeShape.circle,
                        color: Colors.black,
                      ),
                      dataModuleStyle: QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.circle,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    child: Text(
                      "Scan this QR or you can input the following code into your Google Authenticator app",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _secret ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      FutureBuilder<ClipboardData>(
                        future: Clipboard.getData("text/plain"),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            if (snapshot.data.text.contains(_secret)) {
                              return Icon(Icons.done);
                            } else {
                              return IconButton(
                                icon: Icon(Icons.content_copy),
                                onPressed: () {
                                  Clipboard.setData(
                                    new ClipboardData(text: data),
                                  );
                                  setState(() {});
                                },
                              );
                            }
                          }
                          return Container();
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MaterialButton(
                        color: T.primaryColor,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                        onPressed: () async {
                          if (await canLaunch(data))
                            await launch(data);
                          else {
                            Navigator.pop(context);
                            CustomToast.toast(
                              context,
                              'Could not open the Google Authenticator app, please install it and try again',
                            );
                          }
                        },
                        child: Text(
                          'Open Authenticator',
                          style: TextStyle(color: T.textLightColor),
                        ),
                      ),
                      MaterialButton(
                        color: T.primaryColor,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(color: T.textLightColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          } else {
            return Container(
              child: Center(
                child: Text("I'm loading your secret..."),
              ),
            );
          }
        },
      ),
    );
  }
}
