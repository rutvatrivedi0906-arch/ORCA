import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_models.dart';

class SessionService {
  SessionService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveSession({
    required String accessToken,
    required AuthenticatedUser user,
  }) async {
    await _storage.write(key: 'orca_access_token', value: accessToken);
    await _storage.write(key: 'orca_role', value: user.role);
    await _storage.write(key: 'orca_user_id', value: user.id);

    if (user.fisherId != null) {
      await _storage.write(key: 'orca_fisher_id', value: user.fisherId);
    }
  }

  static Future<String?> getAccessToken() =>
      _storage.read(key: 'orca_access_token');

  static Future<String?> getRole() => _storage.read(key: 'orca_role');

  static Future<void> clear() => _storage.deleteAll();
}
