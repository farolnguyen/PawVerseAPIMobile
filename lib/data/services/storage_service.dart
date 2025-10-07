import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';

class StorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  late final SharedPreferences _prefs;

  // Initialize SharedPreferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ========== Secure Storage (JWT Tokens) ==========

  // Save JWT Token
  Future<void> saveToken(String token) async {
    await _secureStorage.write(
      key: AppConfig.tokenKey,
      value: token,
    );
  }

  // Get JWT Token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConfig.tokenKey);
  }

  // Delete JWT Token
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: AppConfig.tokenKey);
  }

  // Save Refresh Token
  Future<void> saveRefreshToken(String refreshToken) async {
    await _secureStorage.write(
      key: AppConfig.refreshTokenKey,
      value: refreshToken,
    );
  }

  // Get Refresh Token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConfig.refreshTokenKey);
  }

  // Delete Refresh Token
  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: AppConfig.refreshTokenKey);
  }

  // Clear all secure storage
  Future<void> clearSecureStorage() async {
    await _secureStorage.deleteAll();
  }

  // ========== Shared Preferences (Settings) ==========

  // Save User Data (JSON string)
  Future<void> saveUserData(String userData) async {
    await _prefs.setString(AppConfig.userKey, userData);
  }

  // Get User Data
  String? getUserData() {
    return _prefs.getString(AppConfig.userKey);
  }

  // Delete User Data
  Future<void> deleteUserData() async {
    await _prefs.remove(AppConfig.userKey);
  }

  // Save Theme Mode
  Future<void> saveThemeMode(String themeMode) async {
    await _prefs.setString(AppConfig.themeKey, themeMode);
  }

  // Get Theme Mode
  String? getThemeMode() {
    return _prefs.getString(AppConfig.themeKey);
  }

  // Save Language
  Future<void> saveLanguage(String language) async {
    await _prefs.setString(AppConfig.languageKey, language);
  }

  // Get Language
  String? getLanguage() {
    return _prefs.getString(AppConfig.languageKey);
  }

  // Save Boolean
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  // Get Boolean
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // Save String
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // Get String
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // Save Int
  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  // Get Int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // Clear all preferences
  Future<void> clearPreferences() async {
    await _prefs.clear();
  }

  // Clear all storage (secure + preferences)
  Future<void> clearAll() async {
    await clearSecureStorage();
    await clearPreferences();
  }

  // Check if user is logged in (has token)
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
