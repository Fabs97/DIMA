import 'package:citylife/screens/homepage/homepage.dart';
import 'package:citylife/screens/login/2fa_login.dart';
import 'package:citylife/screens/login/2fa_login_state.dart';
import 'package:citylife/screens/login/login.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/services/shared_pref_service.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:citylife/utils/badgeDialogState.dart';
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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider.value(
          value: SharedPrefService.getInstance(),
        ),
        ChangeNotifierProvider<AuthService>(
            create: (_) => AuthService.instance()),
        Provider.value(value: StorageService()),
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

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool _isLoadingInfo = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final AuthService authService = context.read<AuthService>();

    authService.checkUserInfoPersistence().then(
          (value) => setState(
            () => _isLoadingInfo = false,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TwoFALoginState(),
        ),
        Provider(create: (context) => BadgeDialogState(context, auth)),
      ],
      child: Consumer<TwoFALoginState>(
        builder: (_, state, __) {
          return _isLoadingInfo
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : (!auth.isAuthenticated
                  ? Login()
                  : ((auth.authUser.twofa && !state.authenticated)
                      ? TwoFactorsAuthentication(userId: auth.authUser.id)
                      : HomePage(
                          userId: auth.authUser.id,
                        )));
        },
      ),
    );
  }
}
