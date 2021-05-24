import 'package:citylife/screens/homepage/homepage.dart';
import 'package:citylife/screens/login/2fa_login.dart';
import 'package:citylife/screens/login/2fa_login_state.dart';
import 'package:citylife/screens/login/login.dart';
import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/services/shared_pref_service.dart';
import 'package:citylife/services/storage_service.dart';
import 'package:citylife/utils/badgeDialogState.dart';
import 'package:citylife/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main({
  SharedPrefService testSharedPrefService,
  UserAPIService testUserAPIService,
  BadgeAPIService testBadgeAPIService,
  ImpressionsAPIService testImpressionsAPIService,
  AuthService testAuthService,
  StorageService testStorageService,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
      WidgetsBinding.instance.window.physicalSize.width <
              WidgetsBinding.instance.window.physicalSize.height
          ? [
              DeviceOrientation.portraitDown,
              DeviceOrientation.portraitUp,
            ]
          : [
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft,
            ]);
  await Firebase.initializeApp();
  runApp(CityLife(
    testSharedPrefService: testSharedPrefService,
    testUserAPIService: testUserAPIService,
    testBadgeAPIService: testBadgeAPIService,
    testImpressionsAPIService: testImpressionsAPIService,
    testAuthService: testAuthService,
    testStorageService: testStorageService,
  ));
}

class CityLife extends StatelessWidget {
  final UserAPIService _userAPIService = UserAPIService();
  final BadgeAPIService _badgeAPIService = BadgeAPIService();
  final ImpressionsAPIService _impressionsAPIService = ImpressionsAPIService();

  final SharedPrefService testSharedPrefService;
  final UserAPIService testUserAPIService;
  final BadgeAPIService testBadgeAPIService;
  final ImpressionsAPIService testImpressionsAPIService;
  final AuthService testAuthService;
  final StorageService testStorageService;

  CityLife({
    Key key,
    this.testSharedPrefService,
    this.testUserAPIService,
    this.testBadgeAPIService,
    this.testImpressionsAPIService,
    this.testAuthService,
    this.testStorageService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider.value(
          value: testSharedPrefService ?? SharedPrefService.getInstance(),
        ),
        Provider.value(value: testUserAPIService ?? _userAPIService),
        Provider.value(value: testBadgeAPIService ?? _badgeAPIService),
        Provider.value(
            value: testImpressionsAPIService ?? _impressionsAPIService),
        ChangeNotifierProvider<AuthService>(
          create: (_) =>
              testAuthService ??
              AuthService.instance(userAPIService: _userAPIService),
        ),
        Provider.value(value: testStorageService ?? StorageService()),
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
        Provider(create: (context) => BadgeDialogState(auth)),
      ],
      child: Consumer2<TwoFALoginState, BadgeAPIService>(
        builder: (_, state, badgeAPIService, __) {
          return _isLoadingInfo
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(T.primaryColor),
                  ),
                )
              : (!auth.isAuthenticated
                  ? Login()
                  : ((auth.authUser.twofa && !state.authenticated)
                      ? TwoFactorsAuthentication(userId: auth.authUser.id)
                      : HomePage(
                          userId: auth.authUser.id,
                          badgeAPIService: badgeAPIService,
                        )));
        },
      ),
    );
  }
}
