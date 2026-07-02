import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRole = 'user_role';

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

  // save cached profile
  static Future<void> saveCachedProfile({
    required String name,
    required String email,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserRole, role);
  }

  // get cached profile
  static Future<Map<String, String>?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyUserName);
    final email = prefs.getString(_keyUserEmail);
    final role = prefs.getString(_keyUserRole);
    if (name == null || email == null) return null;
    return {
      'name': name,
      'email': email,
      'role': role ?? 'user',
    };
  }

  // get access token from here
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    print("Token: ${prefs.getString(_keyAccessToken)}");
    return prefs.getString(_keyAccessToken);
  }

  // get refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyRefreshToken);
  }

  // update access and refresh tokens
  static Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
  }

  static const String _keyCachedTasks = 'cached_tasks';
  static const String _keyPendingSyncActions = 'pending_sync_actions';

  // save cached tasks
  static Future<void> saveCachedTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCachedTasks, jsonEncode(tasks));
  }

  // get cached tasks
  static Future<List<Map<String, dynamic>>> getCachedTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyCachedTasks);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  // save pending sync actions
  static Future<void> savePendingSyncActions(List<Map<String, dynamic>> actions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPendingSyncActions, jsonEncode(actions));
  }

  // get pending sync actions
  static Future<List<Map<String, dynamic>>> getPendingSyncActions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyPendingSyncActions);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static const String _keyCachedLocations = 'cached_locations';

  // save cached locations
  static Future<void> saveCachedLocations(List<Map<String, dynamic>> locations) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCachedLocations, jsonEncode(locations));
  }

  // get cached locations
  static Future<List<Map<String, dynamic>>> getCachedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyCachedLocations);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  // clear  the save data from shareprf
  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyCachedTasks);
    await prefs.remove(_keyPendingSyncActions);
    await prefs.remove(_keyCachedLocations);
    await prefs.remove(_keyUserRole);
  }
}
