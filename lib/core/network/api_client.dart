import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pgb_app/core/utils/shared_prefs_helper.dart';
import 'package:pgb_app/core/constants/api_endpoints.dart';

class ApiClient {
  static Future<bool> _refreshTokens() async {
    debugPrint('ApiClient: Access token expired. Attempting token refresh...');
    try {
      final refreshToken = await SharedPrefsHelper.getRefreshToken();
      if (refreshToken == null) {
        debugPrint('ApiClient: No refresh token found. User logout required.');
        return false;
      }

      final url = '$baseUrl/api/v1/auth/refresh';
      debugPrint('ApiClient: Posting to refresh endpoint: $url');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': refreshToken}),
      );

      debugPrint('ApiClient: Refresh Response status: ${response.statusCode}');
      debugPrint('ApiClient: Refresh Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final newAccess = data['access_token'];
        final newRefresh = data['refresh_token'] ?? refreshToken; // Fallback to current if not returned
        if (newAccess != null) {
          await SharedPrefsHelper.updateTokens(
            accessToken: newAccess,
            refreshToken: newRefresh,
          );
          debugPrint('ApiClient: Tokens successfully updated in Shared Preferences.');
          return true;
        }
      }
    } catch (e) {
      debugPrint('ApiClient: Exception during token refresh: $e');
    }

    debugPrint('ApiClient: Token refresh failed. Clearing auth data.');
    await SharedPrefsHelper.clearAuthData();
    return false;
  }

  static Future<http.Response> get(String url, {Map<String, String>? headers}) async {
    final token = await SharedPrefsHelper.getAccessToken();
    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    var response = await http.get(Uri.parse(url), headers: requestHeaders);

    if (response.statusCode == 401) {
      final refreshed = await _refreshTokens();
      if (refreshed) {
        final newToken = await SharedPrefsHelper.getAccessToken();
        requestHeaders['Authorization'] = 'Bearer $newToken';
        response = await http.get(Uri.parse(url), headers: requestHeaders);
      }
    }

    return response;
  }

  static Future<http.Response> post(String url, {Map<String, String>? headers, dynamic body}) async {
    final token = await SharedPrefsHelper.getAccessToken();
    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    var response = await http.post(Uri.parse(url), headers: requestHeaders, body: body);

    if (response.statusCode == 401) {
      final refreshed = await _refreshTokens();
      if (refreshed) {
        final newToken = await SharedPrefsHelper.getAccessToken();
        requestHeaders['Authorization'] = 'Bearer $newToken';
        response = await http.post(Uri.parse(url), headers: requestHeaders, body: body);
      }
    }

    return response;
  }

  static Future<http.Response> put(String url, {Map<String, String>? headers, dynamic body}) async {
    final token = await SharedPrefsHelper.getAccessToken();
    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    var response = await http.put(Uri.parse(url), headers: requestHeaders, body: body);

    if (response.statusCode == 401) {
      final refreshed = await _refreshTokens();
      if (refreshed) {
        final newToken = await SharedPrefsHelper.getAccessToken();
        requestHeaders['Authorization'] = 'Bearer $newToken';
        response = await http.put(Uri.parse(url), headers: requestHeaders, body: body);
      }
    }

    return response;
  }

  static Future<http.Response> patch(String url, {Map<String, String>? headers, dynamic body}) async {
    final token = await SharedPrefsHelper.getAccessToken();
    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    var response = await http.patch(Uri.parse(url), headers: requestHeaders, body: body);

    if (response.statusCode == 401) {
      final refreshed = await _refreshTokens();
      if (refreshed) {
        final newToken = await SharedPrefsHelper.getAccessToken();
        requestHeaders['Authorization'] = 'Bearer $newToken';
        response = await http.patch(Uri.parse(url), headers: requestHeaders, body: body);
      }
    }

    return response;
  }

  static Future<http.Response> delete(String url, {Map<String, String>? headers}) async {
    final token = await SharedPrefsHelper.getAccessToken();
    final Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?headers,
    };

    var response = await http.delete(Uri.parse(url), headers: requestHeaders);

    if (response.statusCode == 401) {
      final refreshed = await _refreshTokens();
      if (refreshed) {
        final newToken = await SharedPrefsHelper.getAccessToken();
        requestHeaders['Authorization'] = 'Bearer $newToken';
        response = await http.delete(Uri.parse(url), headers: requestHeaders);
      }
    }

    return response;
  }
}
