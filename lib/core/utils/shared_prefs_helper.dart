import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pgb_app/core/services/geofence_manager.dart';

class SharedPrefsHelper {
  static const String _AccToken = 'access_token';
  static const String _rtoken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRole = 'user_role';

  // auth data
  static Future<void> saveAuth({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_AccToken, accessToken);
    await prefs.setString(_rtoken, refreshToken);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
  }

  // write profile
  static Future<void> saveProf({
    required String name,
    required String email,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserRole, role);
  }

  // read profile
  static Future<Map<String, String>?> getProf() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyUserName);
    final email = prefs.getString(_keyUserEmail);
    final role = prefs.getString(_keyUserRole);
    if (name == null || email == null) return null;
    return {'name': name, 'email': email, 'role': role ?? 'user'};
  }

  // get acc tokn
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    print("Token: ${prefs.getString(_AccToken)}");
    return prefs.getString(_AccToken);
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rtoken);
  }

  static Future<void> updateTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_AccToken, accessToken);
    await prefs.setString(_rtoken, refreshToken);
  }

  static const String _keyCachedTasks = 'cached_tasks';
  static const String _keyPendingSyncActions = 'pending_sync_actions';

  // save save tasks
  static Future<void> saveCachedTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCachedTasks, jsonEncode(tasks));
  }

  // get save tasks
  static Future<List<Map<String, dynamic>>> getsaveTasks() async {
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

  // save pending sync
  static Future<void> savePendingSync(
    List<Map<String, dynamic>> actions,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPendingSyncActions, jsonEncode(actions));
  }

  // get pending sync
  static Future<List<Map<String, dynamic>>> getPendingSync() async {
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

  static const String _keysaveLoc = 'cached_locations';

  // save  location
  static Future<void> saveLocations(
    List<Map<String, dynamic>> locations,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keysaveLoc, jsonEncode(locations));
  }

  // getlocation
  static Future<List<Map<String, dynamic>>> getLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keysaveLoc);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  static const String _keyDeactiLoc = 'deactivated_locations';

  // save deactivated locations
  static Future<void> saveDeactiLoc(
    List<Map<String, dynamic>> locations,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyDeactiLoc, jsonEncode(locations));
  }

  // get deactivated locations
  static Future<List<Map<String, dynamic>>> getDeactiLoc() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_keyDeactiLoc);
    if (data == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(data);
      return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  // add deactivated location
  static Future<void> addDeactiLoc(Map<String, dynamic> location) async {
    final list = await getDeactiLoc();
    list.removeWhere((loc) => loc['id'] == location['id']);
    list.add(location);
    await saveDeactiLoc(list);
  }

  // remove deactivated location
  static Future<void> rmvDeactiLoc(String locId) async {
    final list = await getDeactiLoc();
    list.removeWhere((loc) => loc['id'] == locId);
    await saveDeactiLoc(list);
  }

  static Future<void> clearAuthData() async {
    try {
      await GeofenceManager().stopMonitoring();
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_AccToken);
    await prefs.remove(_rtoken);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyCachedTasks);
    await prefs.remove(_keyPendingSyncActions);
    await prefs.remove(_keysaveLoc);
    await prefs.remove(_keyDeactiLoc);
    await prefs.remove(_keyUserRole);
  }
}
