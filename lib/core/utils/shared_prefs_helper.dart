import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';

  // user data save like token name id
  static Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
  }

  // get access token from here
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccessToken);
  }

  // clear  the save data from shareprf
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
  }
}
