import 'package:citylife/screens/homepage/homepage.dart';
import 'package:citylife/screens/login/login.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CityLife());
}

class CityLife extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider.value(value: AuthStatus())
      ],
      child: NotificationListener(
        child: MaterialApp(
          title: 'CityLife',
          theme: T.themeData,
          home: Authenticate(),
        ),
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  const Authenticate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthStatus authStatus = context.watch<AuthStatus>();
    return authStatus.status == Status.Unauth ? Login() : HomePage();
  }
}
