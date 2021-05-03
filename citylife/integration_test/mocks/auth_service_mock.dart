import 'package:citylife/services/auth_service.dart';
import 'package:mockito/mockito.dart';

import 'firebase_auth_mock.dart';

class MockAuthService extends Mock implements AuthService {
  final MockFirebaseAuth auth;

  MockAuthService({this.auth});
}
