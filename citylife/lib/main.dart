import 'package:citylife/models/cl_user.dart';
import 'package:citylife/screens/homepage/homepage.dart';
import 'package:citylife/screens/login/login.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/services/shared_pref_service.dart';
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
  CLUser user;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (context) => AuthService.instance(),
        ),
        FutureProvider.value(
          value: SharedPrefService.getInstance(),
        ),
      ],
      child: NotificationListener(
        child: MaterialApp(
          title: 'CityLife',
          theme: T.themeData,
          home: Authenticate(),
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class Authenticate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = context.watch<AuthService>();

    return FutureBuilder(
        future: authService.checkUserInfoPersistence(),
        initialData: null,
        builder: (context, snapshot) {
          return snapshot.data == null ? Login() : HomePage();
        });
  }
}
