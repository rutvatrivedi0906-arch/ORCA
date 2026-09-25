import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/auth_models.dart';

class SessionService {
  SessionService._();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const _accessTokenKey = 'orca_access_token';
  static const _roleKey = 'orca_role';
  static const _userIdKey = 'orca_user_id';
  static const _fisherIdKey = 'orca_fisher_id';
  static const _preferredLanguageKey = 'orca_preferred_language';

  static Future<void> saveSession({
    required String accessToken,
    required AuthenticatedUser user,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);

    await _storage.write(key: _roleKey, value: user.role);

    await _storage.write(key: _userIdKey, value: user.id);

    if (user.fisherId != null) {
      await _storage.write(key: _fisherIdKey, value: user.fisherId);
    } else {
      await _storage.delete(key: _fisherIdKey);
    }

    await _storage.write(
      key: _preferredLanguageKey,
      value: user.preferredLanguage,
    );
  }

  static Future<String?> getAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  static Future<String?> getRole() {
    return _storage.read(key: _roleKey);
  }

  static Future<String?> getUserId() {
    return _storage.read(key: _userIdKey);
  }

  static Future<String?> getFisherId() {
    return _storage.read(key: _fisherIdKey);
  }

  static Future<String?> getPreferredLanguage() {
    return _storage.read(key: _preferredLanguageKey);
  }

  static Future<void> setPreferredLanguage(String code) {
    return _storage.write(
      key: _preferredLanguageKey,
      value: code.toLowerCase(),
    );
  }

  static Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _roleKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _fisherIdKey);
    await _storage.delete(key: _preferredLanguageKey);
  }
}
