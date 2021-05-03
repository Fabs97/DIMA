import 'package:citylife/services/api_services/badge_api_service.dart';
import 'package:citylife/services/api_services/impressions_api_service.dart';
import 'package:citylife/services/api_services/user_api_service.dart';
import 'package:citylife/services/auth_service.dart';
import 'package:citylife/services/shared_pref_service.dart';
import 'package:citylife/services/storage_service.dart';

import 'api_services_mock.dart';
import 'auth_service_mock.dart';
import 'shared_pref_service_mock.dart';
import 'storage_service_mock.dart';

final AuthService authService = MockAuthService();
final BadgeAPIService badgeAPIservice = MockBadgeAPIService();
final ImpressionsAPIService impressionAPIService = MockImpressionsAPIService();
final SharedPrefService sharedPrefService = MockSharedPrefService();
final StorageService storageService = MockStorageService();
final UserAPIService userAPIService = MockUserAPIService();
